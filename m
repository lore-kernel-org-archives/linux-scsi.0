From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid 1.1.5-2336 driver patch for 2.4.26 - x86_64/em64t ioctl support
Date: Fri, 4 Jun 2004 12:07:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2374F@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C44A4E.0FA7E0E4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:27820 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265845AbUFDQHo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 12:07:44 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i54G7hX23313
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2004 09:07:43 -0700
Received: from otce2k03.adaptec.com (otce2k03.adaptec.com [10.12.1.72])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i54G7fo22623
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2004 09:07:41 -0700
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C44A4E.0FA7E0E4
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

A followup to the patch, Mark Haverkamp noticed a `missing' portion of =
this patch.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org =
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Friday, June 04, 2004 10:12 AM
To: linux-scsi@vger.kernel.org
Subject: aacraid 1.1.5-2336 driver patch for 2.4.26 - x86_64/em64t ioctl =
support

Since there was no comments on the one-piece, I must assume that there =
was nothing glaringly wrong with it ( ;-} ). However, if the patch was =
not accepted due to its size, and/or because I did not get feedback that =
it was actually accepted into the tree and due to the impending delivery =
schedules of distributions; I have decided to take one of the high =
priority patches required for management ioctl support in the =
x86_64/em64t environment and re-apply it. I look forward to your =
comments.

This patch ensures that 32 bit management applications can issue ioctl =
calls to a driver in a 64 bit processor environment.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org =
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Wednesday, May 19, 2004 4:42 PM
To: linux-scsi@vger.kernel.org
Subject: aacraid 1.1.5-2336 driver patch for 2.4.26

This is a one piece patch, I understand that the baby could be thrown =
out with the bathwater. However, I need to head off all the requests to =
my email address for an updated driver by ensuring its public =
availability. This driver has incorporated past submission comments =
*except* for the contentious issues surrounding plug and play device =
handling and device busy check; but those can be edited out pretty =
easily.
=A0
Documentation on the changes is part of the CHANGELOG file enclosed in =
this patch.
=A0
I am looking for comments so as to improve the chances this driver can =
be incorporated as both the 2.4 and the 2.6 aacraid driver; I am working =
with Mark Haverkamp on incorporating the changes present in this driver =
into the 2.6 driver and many of the current features of the 2.6 driver =
have been back merged into this driver since the last submission in an =
effort to aim towards synchronizing the drivers ine both trees.
=A0
Sincerely - Mark Salyzyn

------_=_NextPart_001_01C44A4E.0FA7E0E4
Content-Type: application/octet-stream;
	name="aacraid-compat-2.4.26-1.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid-compat-2.4.26-1.patch
Content-Disposition: attachment;
	filename="aacraid-compat-2.4.26-1.patch"

ZGlmZiAtTnJ1IC91c3Ivc3JjL29yaWcvbGludXgtMi40LjI2L2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY3JhaWQuaCAuL2FhY3JhaWQuaAotLS0gL3Vzci9zcmMvb3JpZy9saW51eC0yLjQuMjYvZHJp
dmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oCU1vbiBBcHIgMTIgMDY6Mjk6MDEgMjAwNAorKysg
Li9hYWNyYWlkLmgJV2VkIEp1biAgMiAxMjo0MjowOSAyMDA0CkBAIC0xMjM2LDkgKzEzOTUsOSBA
QAogCiBzdHJ1Y3QgZmliX2lvY3RsCiB7Ci0JY2hhcgkqZmliY3R4OwotCWludAl3YWl0OwotCWNo
YXIJKmZpYjsKKwl1MzIJZmliY3R4OworCXMzMgl3YWl0OworCWRtYV9hZGRyX3QJZmliOwogfTsK
IAogc3RydWN0IHJldmlzaW9uCg==

------_=_NextPart_001_01C44A4E.0FA7E0E4--
