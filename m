Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996771;
	b=iyPj8In6jIEYd+w2x7ixrLfDYm2edsCEXCsQflqYGsFwbfsVrk64QqdHZQHH8LRZCEw6
	 Nbc3vFljFBUukR+0zJr8+tpgX7cQV7vBbktDhk2xNwvBmYcGbacItU4S/vGNntohCUOLX
	 vDQhun1iO7SlWl+q7qeIH52wzfdl28gQh8XNLV5y2aRoWJAq3dV50B95EirSwAFV4a5rE
	 rZaY1gpsJkfJT9RzmHedygg+StpoKsrd6Hl1WJp+erIfUzQr2BDy+g4OTWvpMpOTUpRxd
	 o8p5ecPkckRCFXpkTN+PabS4LjZQEC6Hr2HJ4FH0jEIu06wFDwvxgk/5BSj33sF7DEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996771;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=MfP/F3jWcx6SsmN84VHbjq9nQMObnGbq61HUtF/GjOg=;
	b=jUewhj+3D67H/u/4YRg4E1lw5qfjLbPh75GCaaoUXIeYLw0fUh4SkgTG0dPe82a6Yiz4
	 qbZkJlGndBDG7IpyJ4zX3NJuu9E0yM4CBqttjykAjXIuxfZc+EuCeh8yf4n55C8VbcHOY
	 5Jsn3baJzkTFBbvfahfqkXLApzOXs8YtvEE0ZVvikFFgwc2Y9z0mAXdWG3m87GHcFf9v/
	 0eR9BAQQVkwGKOAIzEBHdYjeIt/YG3/NW4HWBReujNgqYdapFhneV8EjR1OpExdpLEiWK
	 IJp6wy7eXMgHkTjJPNPcbUIrSlk2KGAV2a+8EqVU6wESFvevud2Vf8OAE4bJY93aZ7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=KqfRM7aB;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574CB606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 574CB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=KqfRM7aB
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso467335a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996771; x=1795601571;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MfP/F3jWcx6SsmN84VHbjq9nQMObnGbq61HUtF/GjOg=;
        b=fGAxPagyLC0zSGB/gqrT7lDkOOaK62fa9hfAYQcWrsOtAZzYQaMml1ShcYmfhgvCg5
         YCRLQ8lUTksyFORXKk6rVsNqQv3hgX5szC6ANjY2GT+HqKXgQsr0mnZWGUw6c3BypWgK
         jiF1MxtHw634jh1tnFuXAWQURsYx4WrgPxtrrou1sMlrbHwan0EoXX7ABzgaMvs1DIg2
         iTRUrThyXFlSEFti6PxGB7KVBHMw2PigErmRU0UyIYpz3fF+lcVgm8G3itzMoFNsUvIE
         O2A7czs2ySNRjZQvbocgiCE6PqYnwrqmcm7s8M+q/10j/deGm389YsOr+Zes51jza0VT
         EVCA==
X-Gm-Message-State: APuU4Z8V2hD6n6GnMJZA8CS0fz+OOWr27x+qFZMCIBgP5X7pWXMvuZcf
	WPufSWHJjd9t+a6k9FCCfKDj7S5ugrPmpyFuvaFuayHiXp2PtCPt357G/VVRQSAGexWYHGoD9wx
	+iH5PRox1qv0oqhradlMkWF0cWZUgPEiCs3bMHqfVIfA1MsYiOKfIB8lqoo82n4Pd8jPTwLjDWq
	v3RFmSITQJVUgxwmSRY9zJaDy0Dxuxcw2kayi6Y/mA4WRCC5gEKgv3dBpL9HSjVKKZSlgvK+fuf
	kxiUoL1kM3CUPIV5orwMSLMjhTfO3kPHNs=
X-Gm-Gg: AZFdTZdHdK6Sj3iU+OkAUY2Ajgzsf6SJGxz4eSu5SfR5xSV4C7Oo4Pj+dTqZvkoPyAv
	8mK6r59aBO449W/8LAMKhJ1FuTSVZQVKYBURdXEXSD3YLIRC/Ryf9Ri0xzTDJtwMH1Ne+XnOqMf
	wbdzButgI7W/vAjnEHulBYR0XgX0k9Xq/Vg68PkzsN9YF5hDWqd1+GticHbrbSFjwweGgK8bVz1
	/Qh/YwZRnq+tb0hSs6+ABm6sDlCZ1O/qWadafGmx/FEyHCEMK3rHnhX6xZ7SuoH9QGAjS19DOmi
	OGCwr6GjorQuOdPVB8XI0p8zp7Hd5ZDlCZ03YuexXQ4zk/hKt50qDHB4I6Zy4XEsjr5hjCTfgOJ
	ANhNdIepkQhuEQkhdjkSNd6AmsxABI7HOOZlv29IAKmAg3F8tak+d2g0WD0Wi8qfhLg5A6fcq+S
	9GW0GpMZjE9F4oG1x1YdUxZEMevvXPtFc/lq2tCRobuMdOIfiTTW4FNw==
X-Received: by 2002:a17:90a:d44b:b0:3ab:f38:2b43 with SMTP id 98e67ed59e1d1-3b3d07c6166mr1776071a91.34.1794996770719;
        Wed, 18 Nov 2026 02:12:50 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d1423d6asm1650124a91.4.2026.11.18.02.12.50
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:50 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ada6ccd402so534892a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996769; x=1795601569; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=MfP/F3jWcx6SsmN84VHbjq9nQMObnGbq61HUtF/GjOg=;
        b=KqfRM7aBqJQAHFWndql9NDKbKDXWt48I/c+qDXCIbK1Z63ZyGr+i7USR1V9FCuNAKV
         ruF+WGjZxNUBzj8yOL6ZnMh7+D+Gn8WcWOl3VL2uxnmV9vR5Jawu47jKk8iG1EwZG0Dr
         RujJXaI8iveXPFCen3fehZztVQPgFW+yFfGrA=
X-Received: by 2002:a17:90b:52c8:b0:3a8:13d6:f740 with SMTP id 98e67ed59e1d1-3b3d07a79fbmr2539795a91.22.1794996768713;
        Wed, 18 Nov 2026 02:12:48 -0800 (PST)
X-Received: by 2002:a17:90b:52c8:b0:3a8:13d6:f740 with SMTP id 98e67ed59e1d1-3b3d07a79fbmr2539765a91.22.1794996768162;
        Wed, 18 Nov 2026 02:12:48 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:47 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	thenzl@redhat.com,
	mgandhi@redhat.com,
	loberman@redhat.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 14/37] scsi: mpt3sas: Fix buffer overflow in _scsih_scsi_ioc_info
Date: Wed, 18 Nov 2026 01:56:23 -0800
Message-Id: <1794995806-5835-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Build the SCSIState description string with a bounds-checked
snprintf() instead of a chain of unbounded strcat()s.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 47255bf9cdda..3c5d6803e56e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -136,7 +136,7 @@
 #define MPT3SAS_HOST_PAGE_SIZE_4K	12
 #define MPT3SAS_NVME_QUEUE_DEPTH	128
 #define MPT_NAME_LENGTH			32	/* generic length of strings */
-#define MPT_STRING_LENGTH		64
+#define MPT_STRING_LENGTH		80
 #define MPI_FRAME_START_OFFSET		256
 #define REPLY_FREE_POOL_SIZE		512 /*(32 maxcredix *4)*(4 times)*/
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 746b3f2f241c..656241678899 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5777,19 +5777,20 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		break;
 	}
 
-	desc_scsi_state[0] = '\0';
 	if (!scsi_state)
 		desc_scsi_state = " ";
-	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID)
-		strcat(desc_scsi_state, "response info ");
-	if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
-		strcat(desc_scsi_state, "state terminated ");
-	if (scsi_state & MPI2_SCSI_STATE_NO_SCSI_STATUS)
-		strcat(desc_scsi_state, "no status ");
-	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_FAILED)
-		strcat(desc_scsi_state, "autosense failed ");
-	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID)
-		strcat(desc_scsi_state, "autosense valid ");
+	else
+		snprintf(desc_scsi_state, MPT_STRING_LENGTH, "%s%s%s%s%s",
+			 (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) ?
+			 "response info " : "",
+			 (scsi_state & MPI2_SCSI_STATE_TERMINATED) ?
+			 "state terminated " : "",
+			 (scsi_state & MPI2_SCSI_STATE_NO_SCSI_STATUS) ?
+			 "no status " : "",
+			 (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_FAILED) ?
+			 "autosense failed " : "",
+			 (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) ?
+			 "autosense valid " : "");
 
 	scsi_print_command(scmd);
 
-- 
2.53.0

