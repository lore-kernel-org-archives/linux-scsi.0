Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996730;
	b=dcj0aJ0AKdlsNFJnxJ0CL/vXIbDib2Cpvh2yOWb6Nwat2BF3aX1FTjta9gIfeWWIXplJ
	 KVgKgsVuQwLKyXH54qWIPYFoSO22e9ol2CyJm6doHpAWFqf6+zlVOBVRggsxM9ZcaSofg
	 irK3tNFvlxlw/hd3f3cRMi2sl6SFcy1LNeIQxYVwpTBuC9hCeNH2adZ6SY/1Eg2JjWH97
	 E3f2ez4HeJuBkRwoiVqdU40CBDjp7fUtDnsk2nVYSF+XfRNGe20xAFWYIWlxaflCimvhQ
	 abIVT9ouxl53fzx7XisiAy5x++FRA/BUjokrrY89r8+Terjj7+gvHjMh8pZpd5H22OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996730;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=VVCG4WUz6iWNtNO5Prccz6JB96v9h69iHppfr3BRV2w=;
	b=CJUB2zrqLmjox+9QCCM98Gmo/SGZGl1PdHUglgjup8AcsyGJk/O/SXT5sHhoyUyyLhEa
	 DEGVg7WbD8FsxlTthEPbAaKVbFKOI3IftFu40AQfSGfNt3S93aALaz2/gSJOwBBkZ90WF
	 xl021Nn4W2rHmx0AjO/QBYbTaadIWy3EQ+2P9Nhzg4WUCZHV/rExiVgRFYbKCcxIcbWhU
	 JQwx5zxchw5U2GSbIbcdVYFY01O4huAgCp6JpkaTyXt6iNL4QLuA0bci6xzN9xkme8JZY
	 YTJoHlRkZKL6zmlEdI1iSc0wng3Z+JMS1mww8MrfuVoUhZw9caVO39oMWOqr/8ipOuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FvUCplcU;
	arc=none smtp.remote-ip=74.125.82.228
Received: from mail-dy1-f228.google.com (mail-dy1-f228.google.com [74.125.82.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDD8606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FDD8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FvUCplcU
Received: by mail-dy1-f228.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso1221535eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996729; x=1795601529;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VVCG4WUz6iWNtNO5Prccz6JB96v9h69iHppfr3BRV2w=;
        b=O6QiLWGCwquxeXiKalqGhTRf1ZFClbY1KseEA7FRAClAYKMpBshaRP6B/d5j0F0sPj
         sUps81+NICFB+qO4BxVEL2i6jTfqMoJZqjeSwaYZHAs2hS/T9IuiweqTwlR0Ooemg7XH
         0KCYFSkkt2ImJoDnpM2brXbfZ89j5Hp8lUeG8jMYkWvTjXgybtOUnYn1RFboCqVhNtG+
         7RoDd2FkB6/Nentfh1TD+NEGMbgSUI0Wd5Ahkp2GsbB2mIwqBUbDINFXGA20YDOICzg3
         F+l4XV3NCyh6gnHPLBjPHF9nT2pepWXFwlbXS02sVmWg19BZ6nR01Qots2rKdgg3prvJ
         EE7w==
X-Gm-Message-State: APuU4Z8RCmWBX+CJbkyxXJ4AfTMFr1kx8Xtx/GY7+gOQeyHaVLXESUel
	ZppOwt2Y+WC1Ql2yzGmH/4wZzkbeX8xRd5nHhDklv22hB3zZTC4k921vK66S/3ULYZL5LaDg3ec
	fmVzuPXmPhK5S6Spl6gyo2blLZ4z3nQ9fmaSpZro8SxAoLeikIun6hER6bAz6jcayayZWyKU25P
	tpE/OnphLUCjHPIwB6y/CMsQD+J7DRA8UMXwZChBPSFvxBSov4bsd8RWJvcw437LrZ8PDNkKT57
	frFKvzlISm/p7CZN2E9m/tkh0jqC7kh8gg=
X-Gm-Gg: AZFdTZfUrQaIwke3Lb0TRVfv1M9Q0Faql57pzpUaMs3zFxggAODesorC254anKroXby
	cnOLkBq3TDJ+AfF9OtN/t0URHjqsW6/w1iMQA2MKtgCjCmqIUcpyqzvDKy1/sao7GcDgmWNiyJr
	oOsBGDRRW7Jebcv4j1Kn3GpAbTZkX2uWxU6KODVfogxZE7AovnE/GyztL0CyA/ZfjfeVzK69dpf
	Wc+ak6/zCz4eSTypnaw5Cn3eqhCht2EZ4cCcvNjp7HFUntH9SAaQOXwKYbXM+O/EafdkPYBCePe
	mhSspIFeKpWZYRUP8Mkfsq3+j0eXi5+fGDv9si700v83//S9/FXliPwmG5eAYknsVh9aUE94ohn
	JVbTzz2gODhxfVIDwBx0Sp7WmD82Nur5EjGk4QjkAVRA7e4GqksQcaTt0ajxOiEqth/mueQQ6PO
	oHlOnyenDHY0XQVXefvy35LpViPgu7ArSH6pED5vyIV676D7Qh6VkI8w==
X-Received: by 2002:a05:693c:26c7:b0:378:a35b:9e1c with SMTP id 5a478bee46e88-38281bfb0b6mr1836791eec.37.1794996728259;
        Wed, 18 Nov 2026 02:12:08 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-382a80be5e6sm67381eec.28.2026.11.18.02.12.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:08 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b08364cdc7so718594a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996726; x=1795601526; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VVCG4WUz6iWNtNO5Prccz6JB96v9h69iHppfr3BRV2w=;
        b=FvUCplcUIiUGzuNMWzq+3B5yddtaCdBV9ePhsubYtojNYotmbycGnc/Wdnr4/2b1Ic
         e4UJqbnRwd0V49SwEPV2P1eouRKXEZdXzk/cNvs8QHNwwVr95ClmBab9bm1tIkJWVTGH
         8sv+qmZfov8U2vMgRVTCvF4bADGFjT7DfT2TE=
X-Received: by 2002:a17:90b:3c89:b0:3b1:8396:ebf8 with SMTP id 98e67ed59e1d1-3b3d076895fmr1914927a91.36.1794996726246;
        Wed, 18 Nov 2026 02:12:06 -0800 (PST)
X-Received: by 2002:a17:90b:3c89:b0:3b1:8396:ebf8 with SMTP id 98e67ed59e1d1-3b3d076895fmr1914907a91.36.1794996725683;
        Wed, 18 Nov 2026 02:12:05 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:05 -0800 (PST)
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
Subject: [PATCH v2 03/37] scsi: mpt3sas: Pin Scsi_Host while an ioctl is using its ioc
Date: Wed, 18 Nov 2026 01:56:12 -0800
Message-Id: <1794995806-5835-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Take a Scsi_Host reference in _ctl_verify_adapter() and release it
once the ioctl is done, so the adapter can't be torn down while an
ioctl is in flight.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 6 ++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..f4eeef572f6e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -447,6 +447,11 @@ _ctl_verify_adapter(int ioc_number, struct MPT3SAS_ADAPTER **iocpp,
 				continue;
 		}
 out:
+		if (!ioc->shost || !scsi_host_get(ioc->shost)) {
+			spin_unlock(&gioc_lock);
+			*iocpp = NULL;
+			return -1;
+		}
 		spin_unlock(&gioc_lock);
 		*iocpp = ioc;
 		return ioc_number;
@@ -2847,6 +2852,7 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	mutex_unlock(&ioc->ctl_cmds.mutex);
 out_unlock_pciaccess:
 	mutex_unlock(&ioc->pci_access_mutex);
+	scsi_host_put(ioc->shost);
 	return ret;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 085d4672db85..f78fc0faad61 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -13494,11 +13494,12 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
+	/* shost must be valid before the ioc becomes visible to ioctls */
+	ioc->shost = shost;
 	INIT_LIST_HEAD(&ioc->list);
 	spin_lock(&gioc_lock);
 	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
 	spin_unlock(&gioc_lock);
-	ioc->shost = shost;
 	ioc->pdev = pdev;
 	ioc->scsi_io_cb_idx = scsi_io_cb_idx;
 	ioc->tm_cb_idx = tm_cb_idx;
-- 
2.53.0

