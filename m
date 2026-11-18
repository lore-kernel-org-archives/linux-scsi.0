Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996810;
	b=kv5JW2/qJ6xvqCHTZOzYbWJTXz52/wRl2FIXYtDYdCh/6qk3iLukqVZIavwJQ6DUm1/v
	 cRPcAwIhoHsIqpRoLQ5JQIBfwKqGrVCQa0t2UWvYVM6/9yMhKUHfoP1KYc9QKa8Pgnx6D
	 NWS4x9MWU0dzvhA2vf1R21sZj24ZfVOGsMZUm2kP5HLRtvOGok7tfC6jnH/lMJUpn3gIx
	 bAPkcZBo8+uNaFDIQx65d5XdThPqj/DeZFGowHYq+7BuAEYIqKG17tTxA1OoHM2ruQ/Ub
	 WzDFf2c35bc8RQjhwf/681I/2IZUImyJgMIgbhLgLIukotlgltbjpBwGqk034Vcw6jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996810;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=XysOXMNNq2CvkDgSnaZdK4STq4MvQIcJKjsu80Js4J0=;
	b=PuZaBBuc/PMxei5Qs12vYea+tF9tR08bqgt6nhIRTh0rGQdWsksWrt6hXHer/91vlHsp
	 T4j2/9RA7DtD+/WkHqA+Jg//YZyu8+ysskolDvlDFatvAIMSygnHgqjIuEKONhIichJqa
	 YnasPFfaNYdsvhFppEsK101627QX0cYqtUf6KUG6NE7MyG/+Y+5yNEmEgW4JdErN1eqgk
	 pY0pqrM/BRqzb1zKX/XJfGYMPpRuUZilwF5eYvgdkR+fyDRXrttkfLQb4OOB5VD7Cqzub
	 MI/EyC5/nMN26Rri7o1W3fHlMuuBU/ET91wkHGV91bdemqjdMs8kVBiuQxnGHW6uh0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OFwPV7we;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E001E606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E001E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=OFwPV7we
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so330771a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996809; x=1795601609;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XysOXMNNq2CvkDgSnaZdK4STq4MvQIcJKjsu80Js4J0=;
        b=foEc2KK+3FLFE7SXtqoZchak4wXVdpYWkHNIbrzN2dB9gYGMHZvApPJfrbnsDBaJe1
         pkO7ofA9K7llPRKwS09A0cdXR+Q0go6DjKOPLltqSoRZqmeNWZpWFDr4KFg0QvyflJOF
         /F+BME0arzil4THcNFXD0RiZNlTvYWFYwTGNv81z7I86c7vj7PvQVStcQLF/Y7XJhFA2
         AoMlCt3J+THdVzrSsc7AyDTX8QKP0YT/pzfIxDPj6D6inU1bzAmKULn/RDd3tK8I2n24
         JQ8dKJbaR/dobjhSYqHdA5eF+/9fJmVMW9/ThgYMXSZxnKDWAE25hqSRosuYbNPrZH5d
         lmaw==
X-Gm-Message-State: APuU4Z9HX8KLepjt6BhiHlWR7c4V3K5QBPLbGsCd0R5f0oVBPES74kFz
	cEp8MMNTnB55Z3x+51Zje8+Cx7kK0qcBs3wliWT9Gnh9x0tMS+V2elruGq4lrYjQBfOQzXYgno5
	4AUOCNIU5Loq/7Yii5dFeSyuIWJ7CLzZM/gUlEj6Zbxb34Wd9CoFU8nWzWUtkzm0bhkcdNQVt4P
	YW1QOnR2dOKjLpZK0ST/C+e2r64Us/+9MMXPbTHee6rxyleCpzGEwUnoe0h/HbOAxqoO/g0gcSF
	R+cUexx62rVxQsw2fuVH+M+zn9zVM0/Y9w=
X-Gm-Gg: AZFdTZdmcLqDHaAespCfqFOYmj/BdAmKk0W26A6KCg8xBY8d+yfEellecjOhecj1Ah1
	TRO7pDnHYzul1qDD/miuIKCqPyLSorlAMdym0gZIQpdPDN478KlR9dg6SPMGBIsRRHaA2F+09ww
	aUXbSeDLPLf/mePH5pebdoMP+EhhSbhPg+gpwRPagSNdck+cZjLS9i55m9sAZRd2zenCUkSnmkP
	gqIfsFYuEQ/Dgj0vaPfTfeuibw5/q1bWeYhc/GV+F/x45g4K+b5odGz9tz1K4JVstmqBtP6W+ii
	xut7s2zNdsfd1DZrTUE4icROasd99GoJLW+NrnLy8IYjDyxIbtNJlkPojTxw5KEgYURAPm9bprj
	1uydvWrLCAO2urfhCu9dkFS7OPzbGpyLjB7Yvv80mm29ChlPTjsYRZA+1pa3P1xbpR57wpSx0kl
	mSiLHl06ZKc1q2FZ1OH0Jae/EAOvuD+SyCZWmQIvBjZiQJnETlqxehMzWI
X-Received: by 2002:a17:90b:4fc1:b0:3b3:ba43:54bf with SMTP id 98e67ed59e1d1-3b3d07b9008mr2009931a91.27.1794996809088;
        Wed, 18 Nov 2026 02:13:29 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d49e6cb4sm446597a91.4.2026.11.18.02.13.28
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:29 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ad53f538d2so605745a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996807; x=1795601607; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XysOXMNNq2CvkDgSnaZdK4STq4MvQIcJKjsu80Js4J0=;
        b=OFwPV7weuULrGeUZrNx8AS+aUayjFOsHKM2C6URqzVGTbDiD+v8MRqZX1w8RAT4+Se
         8qPySAgBsGplfGioUMDCNtAMrRD0cd/2I/XN0Rn4yMRrMJ1DDYjPVS7A0gxfbzTBN9Q8
         6d+ckJ35bYy/vnQNr793L2uB4ea0MSEMXfrFc=
X-Received: by 2002:a17:90b:4c90:b0:3b3:b636:763c with SMTP id 98e67ed59e1d1-3b3d07a204amr2322301a91.22.1794996807149;
        Wed, 18 Nov 2026 02:13:27 -0800 (PST)
X-Received: by 2002:a17:90b:4c90:b0:3b3:b636:763c with SMTP id 98e67ed59e1d1-3b3d07a204amr2322270a91.22.1794996806608;
        Wed, 18 Nov 2026 02:13:26 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:26 -0800 (PST)
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
Subject: [PATCH v2 24/37] scsi: mpt3sas: Require CAP_SYS_RAWIO for mpt2ctl/mpt3ctl ioctls
Date: Wed, 18 Nov 2026 01:56:33 -0800
Message-Id: <1794995806-5835-25-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Gate the ioctl entry point on CAP_SYS_RAWIO rather than relying only
on device node permissions.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 7c5db14645ca..f97967235367 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -56,6 +56,7 @@
 
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/capability.h>
 
 #include "mpt3sas_base.h"
 #include "mpt3sas_ctl.h"
@@ -2739,6 +2740,9 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	enum block_state state;
 	long ret = -ENOIOCTLCMD;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	/* get IOCTL header */
 	if (copy_from_user(&ioctl_header, (char __user *)arg,
 	    sizeof(struct mpt3_ioctl_header))) {
-- 
2.53.0

