Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228907;
	b=Ys9TO60eCXadjijIQAAWhWMuApkBwa9AEIOKY363+BeJxboICNyaqCmfMKhK3q5z4IQf
	 HA0qwmRkVrCDoajPpsd2s/oebtg67bEixh9pBCWsCuTIIXalAOVXVMGtElRZZsKDqolqq
	 PJtG9MQ1YRUhEECw6IismuL8CZ/0IH+DEx54jII5ePVF+toDlCLuKa5qiTmyaYRzBU8dL
	 KM5qWW/HzYIVjGUuqPKlXEH4Dxz/ycH82+UpB3To0AstHlvLUxCPAGx93D/CH7pgBTojC
	 Hd+jJL/FinkaSbjYF3G33Pi/9GCH0VkjIFqwBnAnOyQDoDnaYyYhzzhfLx7NX8YatAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228907;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k/10f5c+oWWOXFNZyBGAsvHHDb+DQboLM334VsQA3NU=;
	b=acCa7lkkpM56o3x69XLOUMpd62BuvVld8SnsJ5v0sDLMNXjwdzhHjdZ81yQt1iiBF6Eq
	 FtUhKhtoUi8LuDZJosCD0aWDvHLYa+CRjCLagsjHAHA0VCFe64yHjGip3LNFYRrt7s2Sm
	 nAvpd+25IMBBfLgbe4lMzm5QOVGjwq3dyQIvmsrJ9Ol3xiBOSq08tIt7gR6uKLmNwELY0
	 jmXrKxDC6ho1xnzZvA0n11p3IDzZBjKzT3ZAZaJPcrjqE7Jl/U7rDv+WuGDbD/GYnlLfX
	 O1vpIiKfEIxRrru7JrLsfaDPNOT34ZYw7IMqAD7BVNcHAnMIacsc2K5Q27jK8QCqj3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FA4606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 23:08:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65FA4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36661f953e4so2449270eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 16:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793228900; x=1793833700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k/10f5c+oWWOXFNZyBGAsvHHDb+DQboLM334VsQA3NU=;
        b=Myor4KUWS2hgUVtCRZ4dKuxHThBGvmlR9fT2ld4ZksB6oB1tjgiHez1E+E5sMiVMJF
         cb/lUR48uUWN9CbrGbjdE0QFaXOfpwwQdwHGGo+UUnZi73sR4mKY7eTDPCoiLcJ2WOaV
         Zr2Z1J8jKSXEwuzviNxFCl5lFdV6tWKLheonwjZAbP/iMGJzsQvBis763w2GM2hDmbOI
         PHinETqrZ7XHeoliehUxei3lBFQ/dbQ5xtPqAh+ivNTIi0adBAHImu85RGFMIvbEBuxF
         t8rX3MCha7m0SfmgceXRRwbxyOD2DQLBt5BQ4sjI/YWoTUuaSdqRP95kfiDiF1l5YTrY
         jcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228900; x=1793833700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k/10f5c+oWWOXFNZyBGAsvHHDb+DQboLM334VsQA3NU=;
        b=LxaetxSmZ2+GnP3GTTSdj/F+ts9zPvvb8Sb1AVoha4mgQ0FXk0bFcuOSBm/etckF6s
         iHPBpN4FSCQtDJ1RmU91nJylbpyfwFEg/c88+rBCz6iV9U26wvADjUcFWhNWKMuCkqfA
         e+/hBEiF0f6Z6l5+xugyoF6aJoL5hyRwQOgcD9Z/iGn2exWhn0+zxPCL/3VX9yZbCwYb
         4hgiEUMzqu5n5iWQSFEiC59/B1XJykBKb7yf6KmVCJOMG4YUXtvOJ5VZaqTQ454195Wv
         /VJgXKoUWsXgzC1S5lFfiEupngaG2vnKvGS/vkpJD70vkqqid46EX8mFVQypTUIg7NpO
         4vfw==
X-Gm-Message-State: AFq9FYJ8K3+tOyYZ8R6E+3viWveHI7wxkrox4Rg9ZFn5fIOJmc9DApjK
	MyMcpAwTWE+ZuYnB0Ll1XsLOf/JioQc3d7R7/QfHTp3/BayZrry7krqZFNrzmLht5l3pYuDUahw
	qiZT3AKmcs9B3RfZhn92y4PvpEdBMNagrU4eoinXWIJPv9rbkP5DMZ1x1urfFy1cvaL8rvmRbCc
	bxFJJnTYcOgd6KKSZ99NT4gEY4glf00Lx4h825xF/CodFKAycibg==
X-Gm-Gg: AYBFou2FMBJ/Y1I3GH/vSDr3KaeLUOqig/a3c8oL85G5Z4Voso9RtlAgO/LvFFOrcUz
	cxny1774c1RNOEM92f0kz4F9k1Qq7PvLWkMkDlENMrekNZgehxdXvQiSm0jwYpK75GVuLgCEUWC
	hRNzFt+fuBKQowBFpR9L5t7HiaQsCeGhBZBJKYe9wfliVs539LdM2drmEbq5EfjlDzIU/8hfKU/
	HnXOTRTyKmmcehkadcSKal1L8ksn65d35uqg9GHHcGJE5IY+wG7P8LpXnd8lIA+XLKKxKN/7X5y
	G2GDo6l1KpIiYnxiUqIkEZ9Od17ONdvV76eJzs3t2wt5hm8Ksn5F3n9mE4wuL0Bijf/g3FYTewU
	FXgyYi+bvbflexg3Cg/CCQYWHCF/J6TU5AhlA73byhv59z9H5fZTrzbbEfjazDjZjqHBSuSH8r3
	mNaREcl+ZydsjdBC8SRMzlPLySiSv7DFYmR+EfinE3wkBckRbmyJ6ZZjccvGmA4EGT2P9JXtY1l
	6/g30RB7l0MmLe7icAzJ96+cIUs2qjhDQLf3ewB1wRS8ijnAGBhiwLuSzhgQCf9sSgw/cUcppA/
	lGOjM0casOWPFArOPXMb5P3vgUiqoxvCeNwh7n5l0+ybbSlnCrMeMndHA+1JbKgXDa7kRiHyCnT
	dhET1Q/Mk7OFZwmduX1RcBWzjNRdx+nmWPOinJVMPPiVNIqrKXgG36wAkq5KAn4Dn/5k95MdTM4
	mfWeE5KDU9obExoknSRk2y
X-Received: by 2002:a05:7301:1888:b0:369:e930:6bc4 with SMTP id 5a478bee46e88-36a20440ab1mr4641426eec.30.1793228900121;
        Wed, 28 Oct 2026 16:08:20 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a26d59f0fsm8156513eec.6.2026.10.28.16.08.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 16:08:19 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v2 1/4] scsi: core: Move REPORT TARGET PORT GROUPS into the SCSI core
Date: Wed, 28 Oct 2026 16:08:04 -0700
Message-ID: <20261028230807.61578-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028230807.61578-1-brian@purestorage.com>
References: <20261028230807.61578-1-brian@purestorage.com>
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

ALUA is a standard SCSI feature, independent of multipathing, but only
the ALUA device handler can currently send REPORT TARGET PORT GROUPS.
Move submit_rtpg() into the SCSI core as scsi_report_tpgs(), together
with the resubmission with a larger buffer that alua_rtpg() did when
the parameter data did not fit, so that the core can read the ALUA
state of a device itself. The parameter data format definitions move to
scsi_proto.h with it.

scsi_dh_alua calls scsi_report_tpgs() with the same timeout, retries
and parameter data format as before.

No functional change.

Suggested-by: Hannes Reinecke <hare@kernel.org>
Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 63 ++++++----------------
 drivers/scsi/scsi_lib.c                    | 52 ++++++++++++++++++
 include/scsi/scsi_device.h                 |  3 ++
 include/scsi/scsi_proto.h                  |  3 ++
 4 files changed, 73 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 87ac0a6d63e5..06eb35cc9d7c 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -29,9 +29,6 @@
 #define TPGS_SUPPORT_TRANSITION		0x80
 #define TPGS_SUPPORT_ALL		0xdf
 
-#define RTPG_FMT_MASK			0x70
-#define RTPG_FMT_EXT_HDR		0x10
-
 #define TPGS_MODE_UNINITIALIZED		 -1
 #define TPGS_MODE_NONE			0x0
 #define TPGS_MODE_IMPLICIT		0x1
@@ -120,34 +117,6 @@ static void release_port_group(struct kref *kref)
 	kfree_rcu(pg, rcu);
 }
 
-/*
- * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
- * @sdev: sdev the command should be sent to
- */
-static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
-		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
-{
-	u8 cdb[MAX_COMMAND_SIZE];
-	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
-				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = sshdr,
-	};
-
-	/* Prepare the command. */
-	memset(cdb, 0x0, MAX_COMMAND_SIZE);
-	cdb[0] = MAINTENANCE_IN;
-	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
-		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
-	else
-		cdb[1] = MI_REPORT_TARGET_PGS;
-	put_unaligned_be32(bufflen, &cdb[6]);
-
-	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
-				ALUA_FAILOVER_TIMEOUT * HZ,
-				ALUA_FAILOVER_RETRIES, &exec_args);
-}
-
 /*
  * submit_stpg - Issue a SET TARGET PORT GROUP command
  *
@@ -518,6 +487,9 @@ static int alua_tur(struct scsi_device *sdev)
 static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	struct scsi_sense_hdr sense_hdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sense_hdr,
+	};
 	struct alua_port_group *tmp_pg;
 	int len, k, off, bufflen = ALUA_RTPG_SIZE;
 	int group_id_old, state_old, pref_old, valid_states_old;
@@ -549,7 +521,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
  retry:
 	err = 0;
-	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
+	retval = scsi_report_tpgs(sdev, &buff, &bufflen,
+				  !(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP),
+				  ALUA_FAILOVER_TIMEOUT * HZ,
+				  ALUA_FAILOVER_RETRIES, &exec_args);
+	if (!buff) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: kmalloc buffer failed\n", __func__);
+		/* Temporary failure, bypass */
+		pg->expiry = 0;
+		return SCSI_DH_DEV_TEMP_BUSY;
+	}
 
 	if (retval) {
 		/*
@@ -581,7 +563,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		}
 
 		/*
-		 * submit_rtpg() has failed on existing arrays
+		 * scsi_report_tpgs() has failed on existing arrays
 		 * when requesting extended header info, and
 		 * the array doesn't support extended headers,
 		 * even though it shouldn't according to T10.
@@ -629,21 +611,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
 	len = get_unaligned_be32(&buff[0]) + 4;
 
-	if (len > bufflen) {
-		/* Resubmit with the correct length */
-		kfree(buff);
-		bufflen = len;
-		buff = kmalloc(bufflen, GFP_KERNEL);
-		if (!buff) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: kmalloc buffer failed\n",__func__);
-			/* Temporary failure, bypass */
-			pg->expiry = 0;
-			return SCSI_DH_DEV_TEMP_BUSY;
-		}
-		goto retry;
-	}
-
 	orig_transition_tmo = pg->transition_tmo;
 	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
 		pg->transition_tmo = buff[5];
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f695a6605815..ebbfe3238d97 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3581,6 +3581,58 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 }
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
 
+/**
+ * scsi_report_tpgs - Issue a REPORT TARGET PORT GROUPS command
+ * @sdev: SCSI device to send the command to
+ * @buff: buffer for the parameter data, replaced if it is too small
+ * @bufflen: length of @buff
+ * @ext_hdr: request the extended header parameter data format
+ * @timeout: command timeout in jiffies
+ * @retries: number of times to retry the command in the midlayer
+ * @args: optional arguments for scsi_execute_cmd()
+ *
+ * Resend the command with a larger buffer if the parameter data does not
+ * fit.
+ *
+ * Return: the result of the last command, or -ENOMEM with *@buff set to
+ * NULL if a larger buffer could not be allocated.
+ */
+int scsi_report_tpgs(struct scsi_device *sdev, unsigned char **buff,
+		     int *bufflen, bool ext_hdr, int timeout, int retries,
+		     const struct scsi_exec_args *args)
+{
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+			REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	u8 cdb[MAX_COMMAND_SIZE] = { };
+	int ret, len;
+
+	cdb[0] = MAINTENANCE_IN;
+	cdb[1] = MI_REPORT_TARGET_PGS;
+	if (ext_hdr)
+		cdb[1] |= MI_EXT_HDR_PARAM_FMT;
+
+ retry:
+	put_unaligned_be32(*bufflen, &cdb[6]);
+	ret = scsi_execute_cmd(sdev, cdb, opf, *buff, *bufflen, timeout,
+			       retries, args);
+	if (ret)
+		return ret;
+
+	len = get_unaligned_be32(&(*buff)[0]) + 4;
+	if (len > *bufflen) {
+		/* Resubmit with the correct length */
+		kfree(*buff);
+		*bufflen = len;
+		*buff = kmalloc(len, GFP_KERNEL);
+		if (!*buff)
+			return -ENOMEM;
+		goto retry;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_report_tpgs);
+
 /**
  * scsi_set_sense - build sense data for a command
  * @scmd:	scsi command for which the sense should be formatted
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e6fd6bc30644..691275db0677 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -583,6 +583,9 @@ extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_lun_serial(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
+int scsi_report_tpgs(struct scsi_device *sdev, unsigned char **buff,
+		     int *bufflen, bool ext_hdr, int timeout, int retries,
+		     const struct scsi_exec_args *args);
 
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 9c7d31aa6bae..6826f2d74407 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -145,6 +145,9 @@
 #define MI_MANAGEMENT_PROTOCOL_IN 0x10
 /* value for MI_REPORT_TARGET_PGS ext header */
 #define MI_EXT_HDR_PARAM_FMT  0x20
+/* format field in byte 4 of the REPORT TARGET PORT GROUPS parameter data */
+#define RTPG_FMT_MASK         0x70
+#define RTPG_FMT_EXT_HDR      0x10
 /* values for maintenance out */
 #define MO_SET_IDENTIFYING_INFORMATION 0x06
 #define MO_SET_TARGET_PGS     0x0a
-- 
2.56.0

