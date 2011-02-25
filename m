From: adam radford <aradford@gmail.com>
Subject: [PATCH 14/14] megaraid_sas: Version and Changelog update
Date: Thu, 24 Feb 2011 20:57:21 -0800
Message-ID: <AANLkTik=nRLsE-oe2PNOStYXTHb1WsWim4zi2n21Ay6P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c18ac4e7972049d142a6f
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1BYE5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:57:22 -0500
Received: by mail-ww0-f44.google.com with SMTP id 39so1696373wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:57:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c18ac4e7972049d142a6f
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas updates the
ChangeLog.megaraid_sas file and driver version of the megaraid_sas
driver.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas	2011-02-24
18:03:18.611403097 -0800
+++ scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas	2011-02-24
19:07:45.017307885 -0800
@@ -1,3 +1,26 @@
+Release Date    : Thu. Feb 24, 2011 17:00:00 PST 2010 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.05.34-rc1
+Old Version     : 00.00.05.29-rc1
+    1. Fix some failure gotos from megasas_probe_one(), etc.
+    2. Add missing check_and_restore_queue_depth() call in
+       complete_cmd_fusion().
+    3. Enable MSI-X before calling megasas_init_fw().
+    4. Call tasklet_schedule() even if outbound_intr_status == 0 for MFI based
+       boards in MSI-X mode.
+    5. Fix megasas_probe_one() to clear PCI_MSIX_FLAGS_ENABLE in msi control
+       register in kdump kernel.
+    6. Fix megasas_get_cmd() to only print "Command pool empty" if
+       megasas_dbg_lvl is set.
+    7. Fix megasas_build_dcdb_fusion() to not filter by TYPE_DISK.
+    8. Fix megasas_build_dcdb_fusion() to use io_request->LUN[1] field.
+    9. Add MR_EVT_CFG_CLEARED to megasas_aen_polling().
+    10. Fix tasklet_init() in megasas_init_fw() to use instancet->tasklet.
+    11. Fix fault state handling in megasas_transition_to_ready().
+    12. Fix max_sectors setting for IEEE SGL's.
+    13. Fix iMR OCR support to work correctly.
+-------------------------------------------------------------------------------
 Release Date    : Tues.  Dec 14, 2010 17:00:00 PST 2010 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:05:39.096276198 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:07:04.337307872 -0800
@@ -18,12 +18,13 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.05.29-rc1
+ *  Version : v00.00.05.34-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
  *           Sumant Patro
  *           Bo Yang
+ *           Adam Radford <linuxraid@lsi.com>
  *
  *  Send feedback to: <megaraidlinux@lsi.com>
  *
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
19:01:39.701306723 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
19:06:52.983307767 -0800
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.05.29-rc1"
-#define MEGASAS_RELDATE				"Dec. 7, 2010"
-#define MEGASAS_EXT_VERSION			"Tue. Dec. 7 17:00:00 PDT 2010"
+#define MEGASAS_VERSION				"00.00.05.34-rc1"
+#define MEGASAS_RELDATE				"Feb. 24, 2011"
+#define MEGASAS_EXT_VERSION			"Thu. Feb. 24 17:00:00 PDT 2011"

 /*
  * Device IDs

--0016e64c18ac4e7972049d142a6f
Content-Type: application/octet-stream; name="megaraid_sas.patch14"
Content-Disposition: attachment; filename="megaraid_sas.patch14"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmnggk0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzIHNjc2ktbWlzYy0yLjYubmV3L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cu
bWVnYXJhaWRfc2FzCi0tLSBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VM
b2cubWVnYXJhaWRfc2FzCTIwMTEtMDItMjQgMTg6MDM6MTguNjExNDAzMDk3IC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9nLm1lZ2FyYWlkX3Nh
cwkyMDExLTAyLTI0IDE5OjA3OjQ1LjAxNzMwNzg4NSAtMDgwMApAQCAtMSwzICsxLDI2IEBACitS
ZWxlYXNlIERhdGUgICAgOiBUaHUuIEZlYiAyNCwgMjAxMSAxNzowMDowMCBQU1QgMjAxMCAtCisJ
CQkoZW1haWxkLWlkOm1lZ2FyYWlkbGludXhAbHNpLmNvbSkKKwkJCUFkYW0gUmFkZm9yZAorQ3Vy
cmVudCBWZXJzaW9uIDogMDAuMDAuMDUuMzQtcmMxCitPbGQgVmVyc2lvbiAgICAgOiAwMC4wMC4w
NS4yOS1yYzEKKyAgICAxLiBGaXggc29tZSBmYWlsdXJlIGdvdG9zIGZyb20gbWVnYXNhc19wcm9i
ZV9vbmUoKSwgZXRjLgorICAgIDIuIEFkZCBtaXNzaW5nIGNoZWNrX2FuZF9yZXN0b3JlX3F1ZXVl
X2RlcHRoKCkgY2FsbCBpbgorICAgICAgIGNvbXBsZXRlX2NtZF9mdXNpb24oKS4KKyAgICAzLiBF
bmFibGUgTVNJLVggYmVmb3JlIGNhbGxpbmcgbWVnYXNhc19pbml0X2Z3KCkuCisgICAgNC4gQ2Fs
bCB0YXNrbGV0X3NjaGVkdWxlKCkgZXZlbiBpZiBvdXRib3VuZF9pbnRyX3N0YXR1cyA9PSAwIGZv
ciBNRkkgYmFzZWQKKyAgICAgICBib2FyZHMgaW4gTVNJLVggbW9kZS4KKyAgICA1LiBGaXggbWVn
YXNhc19wcm9iZV9vbmUoKSB0byBjbGVhciBQQ0lfTVNJWF9GTEFHU19FTkFCTEUgaW4gbXNpIGNv
bnRyb2wKKyAgICAgICByZWdpc3RlciBpbiBrZHVtcCBrZXJuZWwuCisgICAgNi4gRml4IG1lZ2Fz
YXNfZ2V0X2NtZCgpIHRvIG9ubHkgcHJpbnQgIkNvbW1hbmQgcG9vbCBlbXB0eSIgaWYKKyAgICAg
ICBtZWdhc2FzX2RiZ19sdmwgaXMgc2V0LgorICAgIDcuIEZpeCBtZWdhc2FzX2J1aWxkX2RjZGJf
ZnVzaW9uKCkgdG8gbm90IGZpbHRlciBieSBUWVBFX0RJU0suCisgICAgOC4gRml4IG1lZ2FzYXNf
YnVpbGRfZGNkYl9mdXNpb24oKSB0byB1c2UgaW9fcmVxdWVzdC0+TFVOWzFdIGZpZWxkLgorICAg
IDkuIEFkZCBNUl9FVlRfQ0ZHX0NMRUFSRUQgdG8gbWVnYXNhc19hZW5fcG9sbGluZygpLgorICAg
IDEwLiBGaXggdGFza2xldF9pbml0KCkgaW4gbWVnYXNhc19pbml0X2Z3KCkgdG8gdXNlIGluc3Rh
bmNldC0+dGFza2xldC4KKyAgICAxMS4gRml4IGZhdWx0IHN0YXRlIGhhbmRsaW5nIGluIG1lZ2Fz
YXNfdHJhbnNpdGlvbl90b19yZWFkeSgpLgorICAgIDEyLiBGaXggbWF4X3NlY3RvcnMgc2V0dGlu
ZyBmb3IgSUVFRSBTR0wncy4KKyAgICAxMy4gRml4IGlNUiBPQ1Igc3VwcG9ydCB0byB3b3JrIGNv
cnJlY3RseS4KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIFJlbGVhc2UgRGF0ZSAgICA6IFR1ZXMu
ICBEZWMgMTQsIDIwMTAgMTc6MDA6MDAgUFNUIDIwMTAgLQogCQkJKGVtYWlsZC1pZDptZWdhcmFp
ZGxpbnV4QGxzaS5jb20pCiAJCQlBZGFtIFJhZGZvcmQKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYu
bmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1p
c2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDIt
MjQgMTk6MDU6MzkuMDk2Mjc2MTk4IC0wODAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJz
L3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDExLTAyLTI0IDE5OjA3OjA0LjMz
NzMwNzg3MiAtMDgwMApAQCAtMTgsMTIgKzE4LDEzIEBACiAgKiAgRm91bmRhdGlvbiwgSW5jLiwg
NTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKICAq
CiAgKiAgRklMRTogbWVnYXJhaWRfc2FzX2Jhc2UuYwotICogIFZlcnNpb24gOiB2MDAuMDAuMDUu
MjktcmMxCisgKiAgVmVyc2lvbiA6IHYwMC4wMC4wNS4zNC1yYzEKICAqCiAgKiAgQXV0aG9yczog
TFNJIENvcnBvcmF0aW9uCiAgKiAgICAgICAgICAgU3JlZW5pdmFzIEJhZ2Fsa290ZQogICogICAg
ICAgICAgIFN1bWFudCBQYXRybwogICogICAgICAgICAgIEJvIFlhbmcKKyAqICAgICAgICAgICBB
ZGFtIFJhZGZvcmQgPGxpbnV4cmFpZEBsc2kuY29tPgogICoKICAqICBTZW5kIGZlZWRiYWNrIHRv
OiA8bWVnYXJhaWRsaW51eEBsc2kuY29tPgogICoKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2Ry
aXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBzY3NpLW1pc2MtMi42Lm5ldy9kcml2
ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTEtMDItMjQgMTk6MDE6MzkuNzAxMzA2
NzIzIC0wODAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzLmgJMjAxMS0wMi0yNCAxOTowNjo1Mi45ODMzMDc3NjcgLTA4MDAKQEAgLTMzLDkg
KzMzLDkgQEAKIC8qCiAgKiBNZWdhUkFJRCBTQVMgRHJpdmVyIG1ldGEgZGF0YQogICovCi0jZGVm
aW5lIE1FR0FTQVNfVkVSU0lPTgkJCQkiMDAuMDAuMDUuMjktcmMxIgotI2RlZmluZSBNRUdBU0FT
X1JFTERBVEUJCQkJIkRlYy4gNywgMjAxMCIKLSNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJ
CSJUdWUuIERlYy4gNyAxNzowMDowMCBQRFQgMjAxMCIKKyNkZWZpbmUgTUVHQVNBU19WRVJTSU9O
CQkJCSIwMC4wMC4wNS4zNC1yYzEiCisjZGVmaW5lIE1FR0FTQVNfUkVMREFURQkJCQkiRmViLiAy
NCwgMjAxMSIKKyNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJUaHUuIEZlYi4gMjQgMTc6
MDA6MDAgUERUIDIwMTEiCiAKIC8qCiAgKiBEZXZpY2UgSURzCg==
--0016e64c18ac4e7972049d142a6f--
