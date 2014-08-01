# Python 3

import struct

def parse_sift(sift_filepath):

  # keypoints   = 4   x N,
  # descriptors = 128 x N,

  keypoints = []
  descriptors = []

  # Attempt to open the file for reading.
  with open(sift_filepath, 'rb') as file:

    # Read the SIFT file header.
    header = file.read(8)
    expected_header = b'SIFTV4.0'
    if header != expected_header:
      print('ERROR: SIFT file does not start with expected header, ' + sift_filepath)
      return ([], [])

    # Read the specifications of the file.
    num_features, num_feature_dims, num_descriptor_dims = struct.unpack('iii', file.read(12))

    # Verify the file's specifications.
    if num_features <= 0:
      print('ERROR: expected positive, non-zero number of features: ' + str(num_features))
      return ([], [])
    if num_feature_dims != 5:
      print('ERROR: expected 5 feature dimensions: ' + str(num_feature_dims))
      return ([], [])
    if num_descriptor_dims != 128:
      print('ERROR: expected 128 descriptor dimensions: ' + str(num_descriptor_dims))
      return ([], [])

    # Read the keypoints.
    for i in range(num_features):
      x, y, color, scale, orientation = struct.unpack('fffff', file.read(20))
      keypoints.append((x, y, scale, orientation))

    # Read the descriptors.
    for i in range(num_features):
      descriptors.append(file.read(128))

    # Read the SIFT end-of-file marker.
    eof = file.read(4)
    expected_eof = b''.join([bytes([255]), b'EOF'])
    if eof != expected_eof:
      print('ERROR: SIFT file does not end as expected, ' + sift_filepath)
      return ([], [])

  return (keypoints, descriptors)
