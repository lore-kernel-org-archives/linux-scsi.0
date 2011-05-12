From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/8] megaraid_sas: Remove un-used function
Date: Wed, 11 May 2011 18:33:58 -0700
Message-ID: <BANLkTinX3LQ2uxjHL5csTbAs=N7HQx+Vsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6513a1ce43e7004a30a2e4d
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50650 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab1ELBd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:33:58 -0400
Received: by mail-qy0-f181.google.com with SMTP id 14so618486qyg.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:33:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6513a1ce43e7004a30a2e4d
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas removes un-used function
megasas_return_cmd_for_smid().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-05-09
19:33:54.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-05-11
14:44:14.438367889 -0700
@@ -696,22 +696,6 @@
 }

 /*
- * megasas_return_cmd_for_smid -	Returns a cmd_fusion for a SMID
- * @instance:				Adapter soft state
- *
- */
-void
-megasas_return_cmd_for_smid(struct megasas_instance *instance, u16 smid)
-{
-	struct fusion_context *fusion;
-	struct megasas_cmd_fusion *cmd;
-
-	fusion = instance->ctrl_context;
-	cmd = fusion->cmd_list[smid - 1];
-	megasas_return_cmd_fusion(instance, cmd);
-}
-
-/*
  * megasas_get_ld_map_info -	Returns FW's ld_map structure
  * @instance:				Adapter soft state
  * @pend:				Pend the command or not

--0016e6513a1ce43e7004a30a2e4d
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl0ey9g0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMDUtMDkgMTk6MzM6NTQuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1p
c2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMS0w
NS0xMSAxNDo0NDoxNC40MzgzNjc4ODkgLTA3MDAKQEAgLTY5NiwyMiArNjk2LDYgQEAKIH0KIAog
LyoKLSAqIG1lZ2FzYXNfcmV0dXJuX2NtZF9mb3Jfc21pZCAtCVJldHVybnMgYSBjbWRfZnVzaW9u
IGZvciBhIFNNSUQKLSAqIEBpbnN0YW5jZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRlCi0gKgotICov
Ci12b2lkCi1tZWdhc2FzX3JldHVybl9jbWRfZm9yX3NtaWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFu
Y2UgKmluc3RhbmNlLCB1MTYgc21pZCkKLXsKLQlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lv
bjsKLQlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWQ7Ci0KLQlmdXNpb24gPSBpbnN0YW5j
ZS0+Y3RybF9jb250ZXh0OwotCWNtZCA9IGZ1c2lvbi0+Y21kX2xpc3Rbc21pZCAtIDFdOwotCW1l
Z2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oaW5zdGFuY2UsIGNtZCk7Ci19Ci0KLS8qCiAgKiBtZWdh
c2FzX2dldF9sZF9tYXBfaW5mbyAtCVJldHVybnMgRlcncyBsZF9tYXAgc3RydWN0dXJlCiAgKiBA
aW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29mdCBzdGF0ZQogICogQHBlbmQ6CQkJCVBlbmQgdGhlIGNv
bW1hbmQgb3Igbm90Cg==
--0016e6513a1ce43e7004a30a2e4d--
