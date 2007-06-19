From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: correct PERC2/QC and family match quirk list
Date: Tue, 19 Jun 2007 16:05:12 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22E3F@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0189EB36@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7B2AD.26038ABC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:34694 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760579AbXFSUFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 16:05:15 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id D656418B689
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jun 2007 13:05:14 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF0189EB36@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7B2AD.26038ABC
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The Dell PERC2/QC erroneously was listed as having the 31 bit limit
quirk on the interface allocations, removing the reference to repair
this oversight. Also, the 2 quad pci address (family) match catch-all
also retained the 31 bit limit and the 34 SG limit quirks in a paranoid
move. Now, many years later, we find that none of the Adapters that did
trigger with the family match had such quirks; these quirks are all
limited to the 4 quad pci address matches to select legacy adapters
already populated.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

------_=_NextPart_001_01C7B2AD.26038ABC
Content-Type: application/octet-stream;
	name="aacraid_PERC2-QC.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_PERC2-QC.patch
Content-Disposition: attachment;
	filename="aacraid_PERC2-QC.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDctMDYt
MTkgMTU6NTA6MTEuNzk1Njc4OTgxIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwNy0wNi0xOSAxNTo1MToyNy4wMjMyMTA0MzIgLTA0MDAKQEAgLTIyMSwxMiArMjIx
LDEyIEBACiAJeyBhYWNfcnhfaW5pdCwgInBlcmNyYWlkIiwgIkRFTEwgICAgIiwgIlBFUkMgMzIw
L0RDICAgICAiLCAyLCBBQUNfUVVJUktfMzFCSVQgfCBBQUNfUVVJUktfMzRTRyB9LCAvKiBQZXJj
IDMyMC9EQyovCiAJeyBhYWNfc2FfaW5pdCwgImFhY3JhaWQiLCAgIkFEQVBURUMgIiwgIkFkYXB0
ZWMgNTQwMFMgICAiLCA0LCBBQUNfUVVJUktfMzRTRyB9LCAvKiBBZGFwdGVjIDU0MDBTIChNdXN0
YW5nKSovCiAJeyBhYWNfc2FfaW5pdCwgImFhY3JhaWQiLCAgIkFEQVBURUMgIiwgIkFBQy0zNjQg
ICAgICAgICAiLCA0LCBBQUNfUVVJUktfMzRTRyB9LCAvKiBBZGFwdGVjIDU0MDBTIChNdXN0YW5n
KSovCi0JeyBhYWNfc2FfaW5pdCwgInBlcmNyYWlkIiwgIkRFTEwgICAgIiwgIlBFUkNSQUlEICAg
ICAgICAiLCA0LCBBQUNfUVVJUktfMzFCSVQgfCBBQUNfUVVJUktfMzRTRyB9LCAvKiBEZWxsIFBF
UkMyL1FDICovCisJeyBhYWNfc2FfaW5pdCwgInBlcmNyYWlkIiwgIkRFTEwgICAgIiwgIlBFUkNS
QUlEICAgICAgICAiLCA0LCBBQUNfUVVJUktfMzRTRyB9LCAvKiBEZWxsIFBFUkMyL1FDICovCiAJ
eyBhYWNfc2FfaW5pdCwgImhwbnJhaWQiLCAgIkhQICAgICAgIiwgIk5ldFJBSUQgICAgICAgICAi
LCA0LCBBQUNfUVVJUktfMzRTRyB9LCAvKiBIUCBOZXRSQUlELTRNICovCiAKIAl7IGFhY19yeF9p
bml0LCAiYWFjcmFpZCIsICAiREVMTCAgICAiLCAiUkFJRCAgICAgICAgICAgICIsIDIsIEFBQ19R
VUlSS18zMUJJVCB8IEFBQ19RVUlSS18zNFNHIH0sIC8qIERlbGwgQ2F0Y2hhbGwgKi8KIAl7IGFh
Y19yeF9pbml0LCAiYWFjcmFpZCIsICAiTGVnZW5kICAiLCAiUkFJRCAgICAgICAgICAgICIsIDIs
IEFBQ19RVUlSS18zMUJJVCB8IEFBQ19RVUlSS18zNFNHIH0sIC8qIExlZ2VuZCBDYXRjaGFsbCAq
LwotCXsgYWFjX3J4X2luaXQsICJhYWNyYWlkIiwgICJBREFQVEVDICIsICJSQUlEICAgICAgICAg
ICAgIiwgMiwgQUFDX1FVSVJLXzMxQklUIHwgQUFDX1FVSVJLXzM0U0cgfSwgLyogQWRhcHRlYyBD
YXRjaCBBbGwgKi8KKwl7IGFhY19yeF9pbml0LCAiYWFjcmFpZCIsICAiQURBUFRFQyAiLCAiUkFJ
RCAgICAgICAgICAgICIsIDIgfSwgLyogQWRhcHRlYyBDYXRjaCBBbGwgKi8KIAl7IGFhY19ya3Rf
aW5pdCwgImFhY3JhaWQiLCAiQURBUFRFQyAiLCAiUkFJRCAgICAgICAgICAgICIsIDIgfSwgLyog
QWRhcHRlYyBSb2NrZXQgQ2F0Y2ggQWxsICovCiAJeyBhYWNfbmFya19pbml0LCAiYWFjcmFpZCIs
ICJBREFQVEVDICIsICJSQUlEICAgICAgICAgICAgIiwgMiB9IC8qIEFkYXB0ZWMgTkVNRVIvQVJL
IENhdGNoIEFsbCAqLwogfTsK

------_=_NextPart_001_01C7B2AD.26038ABC--
