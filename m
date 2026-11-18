Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975264;
	b=Hevklfk7Ulo3UyXXkl0bUZuzDAUIYvu86npZaKUhXyghzqPTp0xYOU2TWpqlMRPf5Fr9
	 Khmqqw1taT8NKxUeVNhij2EQJMBFLJDb9PtFFFCee+NMK7vmA1nPEYbXIa8tvua8VOdmd
	 InfzllkCil08lFToE4gVtBlLEZdTegD2cQqIXgE+6QA60dlpPET+PR2cD6gOEFIrSYalJ
	 Y3QbOp/fCjolTdSXD7bu6Ohi/o+osxbreBXxTavO9cZrHYbiY3ZBC+5cRs8vrlctCyoby
	 9TUKB9fqK2E8JJKU9IboWc8Nq++rjU5sfbn/8qjDMr+MhiErf2vhdJfTlkQU0AV0t0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975264;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zlP9NFMxivD/7WnoRl1Q8FAK7P9MLDGYvNDfsD3fEW4=;
	b=Cx//DC5iaMW13rJWFCzxei+y8LanlJeblnr+exbguaeJlSJSwHzD0+S+0xKjUe6GfnwY
	 j7/UJd7vPMiz6xz1TiMS1a5SfcYEhKpSCfWahmUiVKXiZOR5Evg8F+UcNCSA1GDyRUEyA
	 i2zBChCOtYjkoEr+wcg9yXzrQYe451lcWiHIIab5m3QmJeWxkFCbTk0Puswg0Lfhsyr8l
	 n1WHCMI3JKyEPtNjCdlCLM2PQIqOiriTwduWkMC70sgQTEtAeWVgcjia6fn5qbqq4zcgM
	 W6EEjkEcaP26sjFsyvo1izS9Yyg9S63713T8rVyg3NY63geE67av1tHLhp+qQZN/QjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qBlEGefP;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F52606A332
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44F52606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qBlEGefP
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2efe591a1f6so2091955ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975264; x=1795580064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zlP9NFMxivD/7WnoRl1Q8FAK7P9MLDGYvNDfsD3fEW4=;
        b=qBlEGefPmzChhdk0wNPA0p/UMgkFWQY21sNi/8IIGLyKp08m7l7KyB/r1ZoAMbwJ4h
         OVaEPgUZPnbF5xccC6AtlcqDtNel9exmin8wCetQDe5cfvhQA2TgwvA6HgREL2iUVA44
         YbdPrhppCtu0FldSSeDZqfe3ArqeoPadec5UaOkkzA64/uEfgaR2/9Xq4atKkX79C9T6
         1CygKU93tyPuzT1CgJQcuCUOZd6QQ7UfTd8rBG6CwG7kGJhvzZXikXc3O6lPShULdirE
         JO7/HaBhRt4xfx47cPymltMF0hxGIstjslClU+fZ3JDAegB4rhSOSPqgEdGey7O2Y9lC
         At0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975264; x=1795580064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zlP9NFMxivD/7WnoRl1Q8FAK7P9MLDGYvNDfsD3fEW4=;
        b=Q7tnd3ZNMF/iqp7PMg/jKMCVo8rv4mdoLPetgUevEDJUCKWulfKpR4bNDxbe7AO6lt
         MZTcsPpOSuwyROJzU1++ktNyvCR8WJTIl/f6/auTnfS1D2hwSk4B8WbRXyt4sJUfyqDF
         a7lqssEidclGaep+kVlwforjuwnx5uO56J9MIknROK6TVTpGzL/O+ffBjBVtQsTz6Hzj
         bS9mpJ8fHkZayRTXlueW42Q0XiaHb3Mhcfq9LZ02N+NTCW4E+qSeIlC7SZrl6qhqWvaW
         58KDVM/E1XD0C33GDkilV7NTME2+FuYgaKvyZBQAb0h/GIRSqrIg7xYMPqyRn62Fy+ua
         S5Pw==
X-Gm-Message-State: APuU4Z++OUu0j3kpMRsL/yGoTGtroGYCL91C0w01Fea9CkDZaNBlk59K
	ZigKgL14A+00roLzE7fdU/4fNYq6AVmg5EMEQtmI+cYeOd05ojkKbQKU
X-Gm-Gg: AZFdTZelJ4oW9WhgArcio1LL8OY0JuxtS/qTUV3C7wit5UFL5xNigNSCcpVgJay8nFF
	X4ywLJnSgbZE5OcfTwDZOk8PeLiEJlEyLNeYgcQt1YdDGkSF5k+MboqseeQVD9F6BCxDRWkqThJ
	8NqzmdsmrJNDRhNPgPnSxgJ9xKDrYtkO2GXw7hI3rbJJ8H9eQo5RzaLO9o3stWsyPfquhE0k4DG
	RiLiiVs1z4gvhUE1+u1dGZt8pp07hL+fwW/sx6e+XDXaXF1EIoSRnKjZyyswSqTQhHwNE2gVFGh
	QqrRA4VgwUZ9WS98ZhlqwOj9CwPZ7fqRZZ+Tm3J5LM6t0kcr1F0fiWqmE+u3bGxt8x7KS7J07Gr
	Lnwf6k3fuOEtneoXwC7y1HxOJxjBDZpomw/ud/qNDyu0J9cPuwVr11lLxn2NmgHrPAJJBlBkze7
	xav35/+cXWdtN9wO/vSJPNn20UVcwZzaVcMFTrNEHVPP2B7nMQEEkCcqxo2Ql+Wt3Lh2lG2ixqr
	pt1qCmtWiJ+jA79OwpB7cg8tBjgTAd15Zs8o1HDiXAjMu+6DIQhLx3B4PBcFdAdi1d3YZ6A0T4z
	ae43ISo8WdHMtEvOmhI3Uw==
X-Received: by 2002:a17:903:186:b0:2ef:e547:e0cd with SMTP id d9443c01a7336-2eff740bb69mr14953535ad.31.1794975263568;
        Tue, 17 Nov 2026 20:14:23 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:23 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 7/8] scsi: target: keep pscsi mode bytes inside the data sgs
Date: Wed, 18 Nov 2026 12:13:10 +0800
Message-Id: <20261118041311.19011-8-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pscsi_complete_cmd() updates the write-protect byte without checking
that the response is long enough to contain it. MODE SENSE (6) needs
byte 2 and MODE SENSE (10) needs byte 3. A shorter allocation can make
the access run past the command buffer.

On tape devices, MODE SELECT reads the block descriptor through
sg_virt() of the first sg. The block length ends at byte 11 for
MODE SELECT (6) and byte 15 for MODE SELECT (10), but neither the
command length nor the first sg's length is checked.

Use the sg copy helpers to access the write-protect byte and copy the
required MODE SELECT prefix into a local buffer. Check both the command
length and the number of bytes copied before using the fields. This
also handles headers and descriptors split across sg entries.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_pscsi.c | 37 ++++++++++++++----------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index fd1b82fc72902..ccf5933da7f0d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -21,6 +21,7 @@
 #include <linux/ratelimit.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -610,21 +611,17 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 		bool read_only = target_lun_is_rdonly(cmd);
 
 		if (read_only) {
-			unsigned char *buf;
-
-			buf = transport_kmap_data_sg(cmd);
-			if (!buf) {
-				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
-			} else {
-				if (cdb[0] == MODE_SENSE_10) {
-					if (!(buf[3] & 0x80))
-						buf[3] |= 0x80;
-				} else {
-					if (!(buf[2] & 0x80))
-						buf[2] |= 0x80;
-				}
-
-				transport_kunmap_data_sg(cmd);
+			unsigned char wp;
+			unsigned int wp_off = (cdb[0] == MODE_SENSE_10) ? 3 : 2;
+
+			if (cmd->data_length > wp_off && cmd->t_data_sg &&
+			    sg_pcopy_to_buffer(cmd->t_data_sg, cmd->t_data_nents,
+					       &wp, 1, wp_off) == 1 &&
+			    !(wp & 0x80)) {
+				wp |= 0x80;
+				sg_pcopy_from_buffer(cmd->t_data_sg,
+						     cmd->t_data_nents, &wp, 1,
+						     wp_off);
 			}
 		}
 	}
@@ -643,15 +640,15 @@ after_mode_sense:
 	 */
 	if (((cdb[0] == MODE_SELECT) || (cdb[0] == MODE_SELECT_10)) &&
 	     scsi_status == SAM_STAT_GOOD) {
-		unsigned char *buf;
+		unsigned char buf[16];
+		unsigned int len = cdb[0] == MODE_SELECT ? 12 : 16;
 		u16 bdl;
 		u32 blocksize;
 
-		buf = sg_virt(&cmd->t_data_sg[0]);
-		if (!buf) {
-			pr_err("Unable to get buf for scatterlist\n");
+		if (cmd->data_length < len || !cmd->t_data_sg ||
+		    sg_copy_to_buffer(cmd->t_data_sg, cmd->t_data_nents,
+				      buf, len) != len)
 			goto after_mode_select;
-		}
 
 		if (cdb[0] == MODE_SELECT)
 			bdl = buf[3];
