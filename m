From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid changes for 2.4.24 kernel to add support for the 2230S (Makefile)
Date: Fri, 13 Feb 2004 15:20:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F255299@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C3F26E.C6FFCA9E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:37856 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264353AbUBMUUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 15:20:12 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i1DKKBJ25385
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2004 12:20:11 -0800
Received: from otce2k03.adaptec.com (otce2k03.adaptec.com [10.12.1.72])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i1DKKB813413
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2004 12:20:11 -0800
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C3F26E.C6FFCA9E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Ooops, forgot the Makefile change to accompany the patch.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Friday, February 13, 2004 2:26 PM
To: linux-scsi
Subject: [PATCH] aacraid changes for 2.4.24 kernel to add support for
the 2230S

This patch adds support for the 2230S Adapter to the aacraid driver.

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C3F26E.C6FFCA9E
Content-Type: application/octet-stream;
	name="rkt.Makefile.patch"
Content-Transfer-Encoding: base64
Content-Description: rkt.Makefile.patch
Content-Disposition: attachment;
	filename="rkt.Makefile.patch"

ZGlmZiAtdSAtUCAtLXJlY3Vyc2l2ZSBsaW51eC0yLjQuMjQvZHJpdmVycy9zY3NpL2FhY3JhaWQv
TWFrZWZpbGUgbGludXgtMi40LjI0LTIzMjIvZHJpdmVycy9zY3NpL2FhY3JhaWQvTWFrZWZpbGUK
LS0tIGxpbnV4LTIuNC4yNC9kcml2ZXJzL3Njc2kvYWFjcmFpZC9NYWtlZmlsZQlUdWUgTWFyIDE4
IDE1OjAyOjQzIDIwMDMKKysrIGxpbnV4LTIuNC4yNC0yMzIyL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L01ha2VmaWxlCUZyaSBGZWIgMTMgMTI6MTY6MTAgMjAwNApAQCAtMSwxMCArMSwxMSBAQAorIyBB
ZGFwdGVjIGFhY3JhaWQKIAotRVhUUkFfQ0ZMQUdTCSs9IC1JJChUT1BESVIpL2RyaXZlcnMvc2Nz
aQorRVhUUkFfQ0ZMQUdTCSs9IC1JJChUT1BESVIpL2RyaXZlcnMvc2NzaSAke0VYVFJBX0ZMQUdT
fQogCiBPX1RBUkdFVAk6PSBhYWNyYWlkLm8KIG9iai1tCQk6PSAkKE9fVEFSR0VUKQogCiBvYmot
eQkJOj0gbGluaXQubyBhYWNoYmEubyBjb21tY3RybC5vIGNvbW1pbml0Lm8gY29tbXN1cC5vIFwK
LQkJICAgZHBjc3VwLm8gcngubyBzYS5vCisJCSAgIGRwY3N1cC5vIHJ4Lm8gc2EubyBya3Qubwog
CiBpbmNsdWRlICQoVE9QRElSKS9SdWxlcy5tYWtlCg==

------_=_NextPart_001_01C3F26E.C6FFCA9E--
