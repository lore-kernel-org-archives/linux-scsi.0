From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Tue, 19 Jan 2016 16:08:10 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601191532210.1312-200000@iolanthe.rowland.org>
References: <1453222373.3588.3.camel@giantmonkey.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1559625215-770959619-1453237690=:1312"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34802 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932702AbcASVIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 16:08:11 -0500
In-Reply-To: <1453222373.3588.3.camel@giantmonkey.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <paul.menzel@giantmonkey.de>
Cc: Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Alexandre Rossi <alexandre.rossi@gmail.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1559625215-770959619-1453237690=:1312
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 19 Jan 2016, Paul Menzel wrote:

> Could you please attach the debugging patch. Hopefully Alexandre, Erich,
> or I will have some spare time to build an image from it.

Actually, this patch is an attempt at a fix.  After looking more 
carefully at your log pictures, I realized what the problem must be.  

It's too bad nobody was able to capture a log where the error 
occurred in sr_runtime_suspend, though -- all the logs in the bug 
report show sd_runtime_resume.

> Alan, thank you a lot for being so responsive and helpful!

You're welcome.

Alan Stern

---1559625215-770959619-1453237690=:1312
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=sd-sr-rpm-fix
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.1601191608100.1312@iolanthe.rowland.org>
Content-Description: 
Content-Disposition: attachment; filename=sd-sr-rpm-fix

IGRyaXZlcnMvc2NzaS9zZC5jIHwgICAgNyArKysrKy0tDQogZHJpdmVycy9z
Y3NpL3NyLmMgfCAgICA0ICsrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDkgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KSW5kZXg6IHVzYi00LjQv
ZHJpdmVycy9zY3NpL3NkLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0t
LSB1c2ItNC40Lm9yaWcvZHJpdmVycy9zY3NpL3NkLmMNCisrKyB1c2ItNC40
L2RyaXZlcnMvc2NzaS9zZC5jDQpAQCAtMzI3NSw4ICszMjc1LDggQEAgc3Rh
dGljIGludCBzZF9zdXNwZW5kX2NvbW1vbihzdHJ1Y3QgZGV2aQ0KIAlzdHJ1
Y3Qgc2NzaV9kaXNrICpzZGtwID0gZGV2X2dldF9kcnZkYXRhKGRldik7DQog
CWludCByZXQgPSAwOw0KIA0KLQlpZiAoIXNka3ApDQotCQlyZXR1cm4gMDsJ
LyogdGhpcyBjYW4gaGFwcGVuICovDQorCWlmICghc2RrcCkJLyogRS5nLjog
cnVudGltZSBzdXNwZW5kIGZvbGxvd2luZyBzZF9yZW1vdmUoKSAqLw0KKwkJ
cmV0dXJuIDA7DQogDQogCWlmIChzZGtwLT5XQ0UgJiYgc2RrcC0+bWVkaWFf
cHJlc2VudCkgew0KIAkJc2RfcHJpbnRrKEtFUk5fTk9USUNFLCBzZGtwLCAi
U3luY2hyb25pemluZyBTQ1NJIGNhY2hlXG4iKTsNCkBAIC0zMzE1LDYgKzMz
MTUsOSBAQCBzdGF0aWMgaW50IHNkX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpk
ZXYpDQogew0KIAlzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwID0gZGV2X2dldF9k
cnZkYXRhKGRldik7DQogDQorCWlmICghc2RrcCkJLyogRS5nLjogcnVudGlt
ZSByZXN1bWUgYXQgdGhlIHN0YXJ0IG9mIHNkX3Byb2JlKCkgKi8NCisJCXJl
dHVybiAwOw0KKw0KIAlpZiAoIXNka3AtPmRldmljZS0+bWFuYWdlX3N0YXJ0
X3N0b3ApDQogCQlyZXR1cm4gMDsNCiANCkluZGV4OiB1c2ItNC40L2RyaXZl
cnMvc2NzaS9zci5jDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gdXNi
LTQuNC5vcmlnL2RyaXZlcnMvc2NzaS9zci5jDQorKysgdXNiLTQuNC9kcml2
ZXJzL3Njc2kvc3IuYw0KQEAgLTE0NCw2ICsxNDQsOSBAQCBzdGF0aWMgaW50
IHNyX3J1bnRpbWVfc3VzcGVuZChzdHJ1Y3QgZGV2DQogew0KIAlzdHJ1Y3Qg
c2NzaV9jZCAqY2QgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCiANCisJaWYg
KCFjZCkJLyogRS5nLjogcnVudGltZSBzdXNwZW5kIGZvbGxvd2luZyBzcl9y
ZW1vdmUoKSAqLw0KKwkJcmV0dXJuIDA7DQorDQogCWlmIChjZC0+bWVkaWFf
cHJlc2VudCkNCiAJCXJldHVybiAtRUJVU1k7DQogCWVsc2UNCkBAIC05ODUs
NiArOTg4LDcgQEAgc3RhdGljIGludCBzcl9yZW1vdmUoc3RydWN0IGRldmlj
ZSAqZGV2KQ0KIAlzY3NpX2F1dG9wbV9nZXRfZGV2aWNlKGNkLT5kZXZpY2Up
Ow0KIA0KIAlkZWxfZ2VuZGlzayhjZC0+ZGlzayk7DQorCWRldl9zZXRfZHJ2
ZGF0YShkZXYsIE5VTEwpOw0KIA0KIAltdXRleF9sb2NrKCZzcl9yZWZfbXV0
ZXgpOw0KIAlrcmVmX3B1dCgmY2QtPmtyZWYsIHNyX2tyZWZfcmVsZWFzZSk7
DQo=
---1559625215-770959619-1453237690=:1312--
