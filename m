Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926732;
	b=tg6v66Ev4WvJwf6tK2GhGJxvW+IY/NhcRlhNhf3P37ChzvNVvWY3Z3FoFtUBKhQwByOp
	 f1yrXiov4yr4kukQm+vd2PNomsvPQMkAWVXsm+xFBVjCDxEGqvFrjedoTJFk217YufQcj
	 7D3eIw+X/Few3+ik+gWDzA32hqNSYpilyfrX4gmEQsGrsiXXo7KLJydd7Je6vmACsYU5l
	 AfbExLP9EoPHyR/qXMz32pIHSveL0QCe/rHDjKqfBff9pysE3F4RZaT3ZqJwuhy19Dmli
	 9mbmpATu+ycLVsE4NDfmwQwnNkEwwKWQYIRVvKDBhkWpTf0pJf5yC3rnBr+ldAOT9pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926732;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=w17RreLHBPCNCqYy7QZTruV5pvMfAMcS59hHCb1oW0Q=;
	b=j0M8iG4uJrmfyJLt2ug4h0cON5b80/mtRtNypHOE1SIO6aX9zWkhYMygq6OMceeS2YEk
	 icFfEcK2pntNAjZ13t1b8M302njzSsN1cod3pU1eX9lURXJtCw/9Hp84Mjiedx0oPW1Ck
	 /bMYOH/y5zrrh/aKvfdZ3jt24DVWlaSu653v90/GE6TH5uWBbY6DPER5tXZqQgUWGO5HZ
	 oMoPaUGGk3K+Oxhr/V8ULY+d99o+02kiwZ1v7u9CsspBak8HD7iJTMxqAel6CK8tTEis8
	 FcqOJkzwKlv1vX74kZ0T1gt0wz+Y13QENX9/wWPPvNuC0Xbl+3maishY4psm+NmQJ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="d/n1kk7v";
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9FD606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC9FD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=d/n1kk7v
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so43880a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926731; x=1794531531;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w17RreLHBPCNCqYy7QZTruV5pvMfAMcS59hHCb1oW0Q=;
        b=XVYGIEA0HUkka5E/vtpF7mdpma1LkCj+UXdGJq5ZbjHEfkjMm31jqELNIB4iThjg+x
         D2DVmrZucdQBzy7AghkIM0OJAuDUZb9ea606x7jw4PwC7J6/CkifM6me4tXo9JUZJKwh
         nRDfElLTYIMLmgX06pD4d0odnhvdJXVBXMFHfK0tVtcbFne0w2FeEVZzSu5KTeC85bgN
         XwDZnNUfJMqKhnbTuQziFQ2TNe9PYJu2613zN9Dqs7A+S5liOq0SUamNzwqCu+8DxmUW
         G9Fk2agLZWKMPjSDXlGD4KZDrIl6r1POe4R6Ar2tKzfGpQwHQxAPaOvdsnNPkb26g2Ic
         Qj+A==
X-Gm-Message-State: APuU4Z+vdorWC21Sz2JW9aut0guUqzEHa59UH/qRDvuIMMeLfitfm0Av
	NwY77MIFiMNUZ5d6ES4O7nJfo3qaEFCMKBls3XJCmTKJpPnLpaFKqc0yAVW+p88thW/6U58uBhA
	XF0olAAoVxki746Azx/MdIwbUxfMUJgsHSOUbi0ZWUw8pKbsqs4CQglRiVNBirNnssW0+tX3JGz
	ef8tmxlZYTc6y6HwRcjyFcrDsSyiuggXd1upoNceFvbwkKeRtaVwfQGEREHJ0MYQJ4y0LO6ZVki
	lPdsi4/Z9IIY5HM0I4Srvxovou7nhjnVus=
X-Gm-Gg: AYBFou2Dkbt9vhXr2dkMQfWq+zHc7VC97/XFOq6Uyo4Bl43aBoPhY82oej87bWVELPB
	jR/7XjxDepSXY53fKFx9pmLq11awmZVQLvgsHwjvw85Fx8W5JlQWA6yF/Y/E+w2vx6VfdgmZB7f
	IDeOedvXU1l17UI8vz1qwbdYTD0i6MAAWeWA8UyZYRkFLNN/3JV19fgBhHzr1+fIaCV2fqxvIeO
	nY/k7rPeMV78xBBsIY89Qxxg/7qfBg5MgrbZxgYg2zrtrIAPbdbjwUaeiOZ7yZJa1CvueQrSu+n
	6D4Lzsb5kVy9IFfMS/qbdb9x9v5IWgTeYclFcBxDLgA6WuKPAiQQBxlGFlZVOQdbWP0kWxLuUdf
	RQbNEGgka2cH79F3HVj5tddcFfG+arFG/58QK5BVcTOmlleDKZkIh1b3UiIB2k/yK8mYpWaU6CX
	Rgs/xwV30zHlQIDa5drqz7tITgNsZiRMvRfWvyHdbJPWfVIFyFqInzTQ==
X-Received: by 2002:a17:90b:4b89:b0:3a6:f1d2:57f8 with SMTP id 98e67ed59e1d1-3b0db5edb65mr783161a91.2.1793926731130;
        Thu, 05 Nov 2026 16:58:51 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b315a756sm2907641a91.2.2026.11.05.16.58.50
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:51 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e9d52f684fso1092875ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926729; x=1794531529; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=w17RreLHBPCNCqYy7QZTruV5pvMfAMcS59hHCb1oW0Q=;
        b=d/n1kk7v0ov+uUYvrvGTVFQV2H4WWRYzzIgdkUCstqEktPDA9wFtHS9kKjSHfk98It
         2OpdEtVQhk/ft62OgoQtEw++S8pRSQUbzPPeiLTrOD0z6nmvkOzkqoLvG+MwHTtgYlen
         O6FcUDgb7kXccATg/Hf56vHGXxoF49KMEhTqU=
X-Received: by 2002:a17:903:2304:b0:2e9:cd03:b432 with SMTP id d9443c01a7336-2ed40e6cbaamr13534295ad.60.1793926729533;
        Thu, 05 Nov 2026 16:58:49 -0800 (PST)
X-Received: by 2002:a17:903:2304:b0:2e9:cd03:b432 with SMTP id d9443c01a7336-2ed40e6cbaamr13534025ad.60.1793926728910;
        Thu, 05 Nov 2026 16:58:48 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:48 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 13/37] scsi: mpt3sas: Validate max_data_size in MPT3EVENTREPORT ioctl
Date: Thu,  5 Nov 2026 16:42:28 -0800
Message-Id: <1793925772-1303-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Reject a max_data_size smaller than the ioctl header size before
using it in size arithmetic.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index a3d725e5f640..4866b3c7d1c1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1367,6 +1367,9 @@ _ctl_eventreport(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
 				 __func__));
 
+	if (karg.hdr.max_data_size < sizeof(struct mpt3_ioctl_header))
+		return -EINVAL;
+
 	number_bytes = karg.hdr.max_data_size -
 	    sizeof(struct mpt3_ioctl_header);
 	max_events = number_bytes/sizeof(struct MPT3_IOCTL_EVENTS);
-- 
2.53.0

