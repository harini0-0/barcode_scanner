class QRResult {

  final String _qrMsg;

  QRResult(this._qrMsg);

  // Method to make GET parameters.
  String toParams() =>
      '?qrMsg=$_qrMsg';


}