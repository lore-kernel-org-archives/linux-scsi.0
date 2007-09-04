From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: Add documentation for new Adaptec, SMC and SUN cards
Date: Tue, 4 Sep 2007 12:55:47 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01DE34E2@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB79D7@otce2k301.adaptec.com> <AE4F746F2AECFC4DA4AADD66A1DFEF01CB811F@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7EF14.70F6A115"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:38071 "HELO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752160AbXIDRKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2007 13:10:20 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id F074B1EE6BA
	for <linux-scsi@vger.kernel.org>; Tue,  4 Sep 2007 09:55:48 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB811F@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7EF14.70F6A115
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add the SMC LP, SUN EM and Adaptec 5405 cards to the aacraid
documentation list of supported products. These cards are picked up with
family match, so no associated code changes.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 Documentation/scsi/aacraid.txt |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7EF14.70F6A115
Content-Type: application/octet-stream;
	name="aacraid_SMC_SUN.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_SMC_SUN.patch
Content-Disposition: attachment;
	filename="aacraid_SMC_SUN.patch"

ZGlmZiAtcnUgYS9Eb2N1bWVudGF0aW9uL3Njc2kvYWFjcmFpZC50eHQgYi9Eb2N1bWVudGF0aW9u
L3Njc2kvYWFjcmFpZC50eHQKLS0tIGEvRG9jdW1lbnRhdGlvbi9zY3NpL2FhY3JhaWQudHh0CTIw
MDctMDktMDQgMTI6NDA6MTcuNzYxMDQ4MjczIC0wNDAwCisrKyBiL0RvY3VtZW50YXRpb24vc2Nz
aS9hYWNyYWlkLnR4dAkyMDA3LTA5LTA0IDEyOjUwOjA1Ljc4NTcyNzgxMCAtMDQwMApAQCAtMzgs
MTAgKzM4LDggQEAKIAk5MDA1OjAyODY6OTAwNTowMmFjCUFkYXB0ZWMJMTgwMCAoVHlwaG9vbjQ0
KQogCTkwMDU6MDI4NTo5MDA1OjAyYjUJQWRhcHRlYwk1NDQ1IChWb29kb280NCkKIAk5MDA1OjAy
ODU6MTVkOTowMmI1CVNNQwlBT0MtVVNBUy1TNGkKLQk5MDA1OjAyODU6MTVkOTowMmM5CVNNQwlB
T0MtVVNBUy1TNGlSCiAJOTAwNTowMjg1OjkwMDU6MDJiNglBZGFwdGVjCTU4MDUgKFZvb2Rvbzgw
KQogCTkwMDU6MDI4NToxNWQ5OjAyYjYJU01DCUFPQy1VU0FTLVM4aQotCTkwMDU6MDI4NToxNWQ5
OjAyY2EJU01DCUFPQy1VU0FTLVM4aVIKIAk5MDA1OjAyODU6OTAwNTowMmI3CUFkYXB0ZWMJNTA4
NSAoVm9vZG9vMDgpCiAJOTAwNTowMjg1OjkwMDU6MDJiYglBZGFwdGVjCTM0MDUgKE1hcmF1ZGVy
NDBMUCkKIAk5MDA1OjAyODU6OTAwNTowMmJjCUFkYXB0ZWMJMzgwNSAoTWFyYXVkZXI4MExQKQpA
QCAtNTAsOSArNDgsMTQgQEAKIAk5MDA1OjAyODU6OTAwNTowMmJlCUFkYXB0ZWMJMzE2MDUgKE1h
cmF1ZGVyMTYwKQogCTkwMDU6MDI4NTo5MDA1OjAyYzMJQWRhcHRlYwk1MTIwNSAoVm9vZG9vMTIw
KQogCTkwMDU6MDI4NTo5MDA1OjAyYzQJQWRhcHRlYwk1MTYwNSAoVm9vZG9vMTYwKQorCTkwMDU6
MDI4NToxNWQ5OjAyYzkJU01DCUFPQy1VU0FTLVM0aVIKKwk5MDA1OjAyODU6MTVkOTowMmNhCVNN
QwlBT0MtVVNBUy1TOGlSCiAJOTAwNTowMjg1OjkwMDU6MDJjZQlBZGFwdGVjCTUxMjQ1IChWb29k
b28xMjQpCiAJOTAwNTowMjg1OjkwMDU6MDJjZglBZGFwdGVjCTUxNjQ1IChWb29kb28xNjQpCiAJ
OTAwNTowMjg1OjkwMDU6MDJkMAlBZGFwdGVjCTUyNDQ1IChWb29kb28yNDQpCisJOTAwNTowMjg1
OjkwMDU6MDJkMQlBZGFwdGVjCTU0MDUgKFZvb2RvbzQwKQorCTkwMDU6MDI4NToxNWQ5OjAyZDIJ
U01DCUFPQy1VU0FTLVM4aS1MUAorCTkwMDU6MDI4NToxNWQ5OjAyZDMJU01DCUFPQy1VU0FTLVM4
aVItTFAKIAkxMDExOjAwNDY6OTAwNTowMzY0CUFkYXB0ZWMJNTQwMFMgKE11c3RhbmcpCiAJOTAw
NTowMjg3OjkwMDU6MDgwMAlBZGFwdGVjCVRoZW1pc3RvIChKdXBpdGVyKQogCTkwMDU6MDIwMDo5
MDA1OjAyMDAJQWRhcHRlYwlUaGVtaXN0byAoSnVwaXRlcikKQEAgLTEwMyw2ICsxMDYsNyBAQAog
CTkwMDU6MDI4NToxMDhlOjdhYWMJU1VOCVNUSyBSQUlEIFJFTSAoVm9vZG9vNDQgQ295b3RlKQog
CTkwMDU6MDI4NToxMDhlOjAyODYJU1VOCVNUSyBSQUlEIElOVCAoQ291Z2FyKQogCTkwMDU6MDI4
NToxMDhlOjAyODcJU1VOCVNUSyBSQUlEIEVYVCAoUHJvbWV0aGV1cykKKwk5MDA1OjAyODU6MTA4
ZTo3YWFlCVNVTglTVEsgUkFJRCBFTSAoTmFydmkpCiAKIFBlb3BsZQogLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQo=

------_=_NextPart_001_01C7EF14.70F6A115--
