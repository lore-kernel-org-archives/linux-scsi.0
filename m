From: adam radford <aradford@gmail.com>
Subject: [PATCH 11/11]: megaraid_sas: Documentation/scsi/ChangeLog.megaraid_sas
 update
Date: Tue, 14 Dec 2010 19:11:56 -0800
Message-ID: <AANLkTikKhNaBpxLiwENzEL+LkFdG+bnbpxv41MhNixb-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163630ffe3bd58e604976a4c55
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61477 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab0LODL5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 22:11:57 -0500
Received: by qyk12 with SMTP id 12so1540934qyk.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 19:11:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--00163630ffe3bd58e604976a4c55
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch updates the Documentation/scsi/ChangeLog.megaraid_sas file.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/Documentation/scsi/ChangeLog.megaraid_sas
linux-2.6.37-rc5.new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.37-rc5.old/Documentation/scsi/ChangeLog.megaraid_sas	2010-12-06
20:09:04.000000000 -0800
+++ linux-2.6.37-rc5.new/Documentation/scsi/ChangeLog.megaraid_sas	2010-12-14
17:32:42.000000000 -0800
@@ -1,3 +1,25 @@
+Release Date    : Tues.  Dec 14, 2010 17:00:00 PST 2010 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.05.29-rc1
+Old Version     : 00.00.04.31-rc1
+    1. Rename megaraid_sas.c to megaraid_sas_base.c.
+    2. Update GPL headers.
+    3. Add MSI-X support and 'msix_disable' module parameter.
+    4. Use lowest memory bar (for SR-IOV VF support).
+    5. Add struct megasas_instance_temlate changes, and change all code to use
+       new instance entries:
+
+       irqreturn_t (*service_isr )(int irq, void *devp);
+       void (*tasklet)(unsigned long);
+       u32 (*init_adapter)(struct megasas_instance *);
+       u32 (*build_and_issue_cmd) (struct megasas_instance *,
+       struct scsi_cmnd *);
+       void (*issue_dcmd) (struct megasas_instance *instance,
+                              struct megasas_cmd *cmd);
+
+   6. Add code to support MegaRAID 9265/9285 controllers device id (0x5b).
+-------------------------------------------------------------------------------
 1 Release Date    : Thur.  May 03, 2010 09:12:45 PST 2009 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Bo Yang

--00163630ffe3bd58e604976a4c55
Content-Type: application/octet-stream; name="megaraid_sas.patch11"
Content-Disposition: attachment; filename="megaraid_sas.patch11"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpn5d0j0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdl
TG9nLm1lZ2FyYWlkX3NhcyBsaW51eC0yLjYuMzctcmM1Lm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kv
Q2hhbmdlTG9nLm1lZ2FyYWlkX3NhcwotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvRG9jdW1lbnRh
dGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdhcmFpZF9zYXMJMjAxMC0xMi0wNiAyMDowOTowNC4wMDAw
MDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L0RvY3VtZW50YXRpb24vc2NzaS9D
aGFuZ2VMb2cubWVnYXJhaWRfc2FzCTIwMTAtMTItMTQgMTc6MzI6NDIuMDAwMDAwMDAwIC0wODAw
CkBAIC0xLDMgKzEsMjUgQEAKK1JlbGVhc2UgRGF0ZSAgICA6IFR1ZXMuICBEZWMgMTQsIDIwMTAg
MTc6MDA6MDAgUFNUIDIwMTAgLQorCQkJKGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20p
CisJCQlBZGFtIFJhZGZvcmQKK0N1cnJlbnQgVmVyc2lvbiA6IDAwLjAwLjA1LjI5LXJjMQorT2xk
IFZlcnNpb24gICAgIDogMDAuMDAuMDQuMzEtcmMxCisgICAgMS4gUmVuYW1lIG1lZ2FyYWlkX3Nh
cy5jIHRvIG1lZ2FyYWlkX3Nhc19iYXNlLmMuCisgICAgMi4gVXBkYXRlIEdQTCBoZWFkZXJzLgor
ICAgIDMuIEFkZCBNU0ktWCBzdXBwb3J0IGFuZCAnbXNpeF9kaXNhYmxlJyBtb2R1bGUgcGFyYW1l
dGVyLgorICAgIDQuIFVzZSBsb3dlc3QgbWVtb3J5IGJhciAoZm9yIFNSLUlPViBWRiBzdXBwb3J0
KS4KKyAgICA1LiBBZGQgc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2VfdGVtbGF0ZSBjaGFuZ2VzLCBh
bmQgY2hhbmdlIGFsbCBjb2RlIHRvIHVzZQorICAgICAgIG5ldyBpbnN0YW5jZSBlbnRyaWVzOgor
CisgICAgICAgaXJxcmV0dXJuX3QgKCpzZXJ2aWNlX2lzciApKGludCBpcnEsIHZvaWQgKmRldnAp
OworICAgICAgIHZvaWQgKCp0YXNrbGV0KSh1bnNpZ25lZCBsb25nKTsKKyAgICAgICB1MzIgKCpp
bml0X2FkYXB0ZXIpKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICopOworICAgICAgIHUzMiAoKmJ1
aWxkX2FuZF9pc3N1ZV9jbWQpIChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqLAorICAgICAgIHN0
cnVjdCBzY3NpX2NtbmQgKik7CisgICAgICAgdm9pZCAoKmlzc3VlX2RjbWQpIChzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBz
dHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCk7CisKKyAgIDYuIEFkZCBjb2RlIHRvIHN1cHBvcnQgTWVn
YVJBSUQgOTI2NS85Mjg1IGNvbnRyb2xsZXJzIGRldmljZSBpZCAoMHg1YikuCistLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCiAxIFJlbGVhc2UgRGF0ZSAgICA6IFRodXIuICBNYXkgMDMsIDIwMTAgMDk6
MTI6NDUgUFNUIDIwMDkgLQogCQkJKGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAJ
CQlCbyBZYW5nCg==
--00163630ffe3bd58e604976a4c55--
