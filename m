From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] dpt_i2o changes for 2.4.24 kernel in support of 64 bit and bitrot (README.dpti)
Date: Tue, 10 Feb 2004 15:07:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F25500A@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C3F011.8F867760"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:41945 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265170AbUBJUHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 15:07:53 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i1AK7qJ00421
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2004 12:07:52 -0800
Received: from otce2k03.adaptec.com (otce2k03.adaptec.com [10.12.1.72])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i1AK7q818033
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2004 12:07:52 -0800
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C3F011.8F867760
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This documents the supported adapters.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Salyzyn, Mark=20
Sent: Tuesday, February 10, 2004 3:05 PM
To: 'linux-scsi'
Subject: [PATCH] dpt_i2o changes for 2.4.24 kernel in support of 64 bit
and bitrot

Read the CHANGELOG in set of patches for complete description of all the
history and modifications to the driver.

This is a whole scale synchronization of the driver in the 2.4.24 tree
to the Adaptec source code. I know the drill, this is just too big to be
accepted ;-> but it will be very difficult to separate out such a
fundamental set of changes in the driver.

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C3F011.8F867760
Content-Type: application/octet-stream;
	name="dpt_i2o.README.dpti.2.4.patch"
Content-Transfer-Encoding: base64
Content-Description: dpt_i2o.README.dpti.2.4.patch
Content-Disposition: attachment;
	filename="dpt_i2o.README.dpti.2.4.patch"

ZGlmZiAtdSAtUCAtLXJlY3Vyc2l2ZSBsaW51eC0yLjQuMjQvZHJpdmVycy9zY3NpL1JFQURNRS5k
cHRpIGxpbnV4LTIuNC4yNC0yMzIyL2RyaXZlcnMvc2NzaS9SRUFETUUuZHB0aQotLS0gbGludXgt
Mi40LjI0L2RyaXZlcnMvc2NzaS9SRUFETUUuZHB0aQlTdW4gU2VwICA5IDEwOjUyOjM1IDIwMDEK
KysrIGxpbnV4LTIuNC4yNC0yMzIyL2RyaXZlcnMvc2NzaS9SRUFETUUuZHB0aQlXZWQgRmViICA0
IDEwOjE4OjUzIDIwMDQKQEAgLTEsNCArMSw0IEBACi0gLyogVEVSTVMgQU5EIENPTkRJVElPTlMg
T0YgVVNFCisvKiBURVJNUyBBTkQgQ09ORElUSU9OUyBPRiBVU0UKICAqIAogICogUmVkaXN0cmli
dXRpb24gYW5kIHVzZSBpbiBzb3VyY2UgZm9ybSwgd2l0aCBvciB3aXRob3V0IG1vZGlmaWNhdGlv
biwgYXJlCiAgKiBwZXJtaXR0ZWQgcHJvdmlkZWQgdGhhdCByZWRpc3RyaWJ1dGlvbnMgb2Ygc291
cmNlIGNvZGUgbXVzdCByZXRhaW4gdGhlCkBAIC01Niw4ICs1NiwxMyBAQAogICogICAgICAgICBG
VyB3aXRob3V0IGhhdmluZyB0byByZWJvb3QpCiAgKiAgICAgIENoYW5nZWQgcHJvYyBvdXRwdXQK
ICAqCisgKiBWMi41CisgKiAgIENoYW5nZXM6CisgKglBZGRlZCA2NCBiaXQgU2NhdHRlciBHYXRo
ZXIgd2hlbiBjb21waWxlZCBvbiBiaWcgbWVtb3J5IGFhY2Nlc3MKKyAqCSAgIGFyY2hpdGVjdHVy
ZXMuCisgKglBbHRlcmVkIGRyaXZlciBpbiBzdXBwb3J0IG9mIDIuNSsga2VybmVscworICoKICAq
IFRPRE86Ci0gKiAgICAgIEFkZCA2NCBiaXQgU2NhdHRlciBHYXRoZXIgd2hlbiBjb21waWxlZCBv
biA2NCBiaXQgYXJjaGl0ZWN0dXJlcwogICogICAgICBBZGQgc3BhcnNlIGx1biBzY2FubmluZyAK
ICAqICAgICAgQWRkIGNvZGUgdGhhdCBjaGVja3MgaWYgYSBkZXZpY2UgdGhhdCBoYWQgYmVlbiB0
YWtlbiBvZmZsaW5lIGlzCiAgKiAgICAgICAgIG5vdyBvbmxpbmUgKGF0IHRoZSBGVyBsZXZlbCkg
d2hlbiB0ZXN0IHVuaXQgcmVhZHkgb3IgaW5xdWlyeSAKQEAgLTc5LDUgKzg0LDIxIEBACiAgKiBp
biB0aGUgaW9jdGxzLiAgVGhleSBhcmUgd3JpdHRlbiB0byBiZSBwb3J0YWJsZS4gIFRoZXkgYXJl
IGhhcmQgdG8gcmVhZCwgYnV0IEkgbmVlZAogICogdG8gdXNlIHRoZW0gJ2FzIGlzJyBvciBJIGNh
biBtaXNzIGNoYW5nZXMgaW4gdGhlIGludGVyZmFjZS4KICAqCisgKiBDYXJkcyBzdXBwb3J0ZWQ6
CisgKglQTTI1NTQKKyAqCVBNMjY1NAorICoJUE0yNTY0CisgKglQTTM3NTQKKyAqCVBNMzc1NQor
ICoJUE0zNzU3CisgKgkzMjAwUworICoJMzQwMFMKKyAqCTMyMTBTCisgKgkzNDEwUworICoJMjAw
MFMKKyAqCTIwMDVTCisgKgkyMDE1UworICoJMjAyMFMKKyAqCTI0MDBBCiAgKi8KIAo=

------_=_NextPart_001_01C3F011.8F867760--
