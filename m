From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: qla2300 failed to initialize adapter on 2.6.7-rc3
Date: Tue, 8 Jun 2004 11:34:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD020E@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C44D87.334AE8CC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:14137 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265285AbUFHSgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 14:36:04 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jan-Frode Myklebust <janfrode@parallab.uib.no>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C44D87.334AE8CC
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On , linux-scsi-owner@vger.kernel.org wrote:
> I only tried once since it's on our NFS-server and I wanted to avoid
> downtime, but ... when booting 2.6.7-rc3 it failed to initialize my
> qla2300 fibre channel adapter:
>

Try out the attached patch -- this should be safe and corrects a small
oversight on my part when dealing with configure_fabric() failure
statuses.

Regards,
Andrew Vasquez
QLogic Corporation

------_=_NextPart_001_01C44D87.334AE8CC
Content-Type: application/octet-stream;
	name="sns_plogi_fail.diff"
Content-Transfer-Encoding: base64
Content-Description: sns_plogi_fail.diff
Content-Disposition: attachment;
	filename="sns_plogi_fail.diff"

LS0tIGxpbnV4LTIuNi43LXJjMy9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jLm9yaWcJ
MjAwNC0wNi0wOCAxMDo1NToyNi40MTg2NzcxNDQgLTA3MDAKKysrIGxpbnV4LTIuNi43LXJjMy9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jCTIwMDQtMDYtMDggMTA6NTc6NTAuNTk3NzU4
NTkyIC0wNzAwCkBAIC0yMzM0LDcgKzIzMzQsNyBAQAogCQkJICAgICJGYWlsZWQgU05TIGxvZ2lu
OiBsb29wX2lkPSV4IG1iWzBdPSV4IG1iWzFdPSV4ICIKIAkJCSAgICAibWJbMl09JXggbWJbNl09
JXggbWJbN109JXhcbiIsIFNJTVBMRV9OQU1FX1NFUlZFUiwKIAkJCSAgICBtYlswXSwgbWJbMV0s
IG1iWzJdLCBtYls2XSwgbWJbN10pOwotCQkJcmV0dXJuIChRTEFfRlVOQ1RJT05fRkFJTEVEKTsK
KwkJCXJldHVybiAoUUxBX1NVQ0NFU1MpOwogCQl9CiAKIAkJaWYgKHRlc3RfYW5kX2NsZWFyX2Jp
dChSRUdJU1RFUl9GQzRfTkVFREVELCAmaGEtPmRwY19mbGFncykpIHsK

------_=_NextPart_001_01C44D87.334AE8CC--
