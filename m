Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996802;
	b=5ZH5rqIXshPqAHhzNUlt701Ov9zxWkV0UFf1wAP3uYXX/Tv+md1GLGzT688zVrorUIcL
	 bE6x0qlq97IBcVIyo2VIvHKZglmM2NIufK50gIh0AzP1xZiB2TL5jCIgUZwO5jyx45yE0
	 lfEs/EVCnzOmvKmIDiLTwMMa9SpV1MTw0E8QNmW7G62rXmFSqavdckgtBUWdKQzb1kc46
	 s3505/hXgoTnWkcpMx7rU8sKmkNy3mWdeyolxW1T2odXKySrAJnj+OVhcYkgJ6p2xnL6R
	 hMZTlGc5QZ7E9Hd4I/jxeHUDHHmlu5qwghlLfxC+AQ72Wg4iMnfDYoMLKRfV+Z5X8DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996802;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=F2ePSvYeiNUU5ptimEfx1WbPqwfjs2RpbUKuXWRqUhU=;
	b=c0LjYEfut5lq0aewDs4vXcndcqZJYYVxQ0tU/E5sAXT3kOjpb3OM+x1HzXLAHbh8wt8u
	 SWuYBYoB8K3N0ZGxtfiyz4KDwqRAo/5FmP7Rpl6KzSib8ltptliHOPc6CrdWS4zME2mCx
	 d4H/wgROOTk/dScAnlQNC2UiDo0sJf2znydh9fusulSqjMk6eUUNYHuFFOMD1NfJd5hsu
	 St7DrYDmGf6NzH/S+8Y6WQCvYq/MpKqbhQClAQ6Of5cQqW0/gKJ/Oqbtj2YZlPE0MOvH9
	 +8aqhge1jQ++JBvshCKSENOGyJGYFVSvoiQZjT3gM5i4AVEnX9r953xVDzp3Yw+sc5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VT4Oglzl;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CA2606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1CA2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VT4Oglzl
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso416170a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996801; x=1795601601;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F2ePSvYeiNUU5ptimEfx1WbPqwfjs2RpbUKuXWRqUhU=;
        b=RGqmiV5C4BV0BAdHj/QtgjPA0ztTxhUZ15ONdc9kQUEjfXtje0n7Kg78LnJSv2ZdlO
         1y8UQ/07Q1ZDNHbURK2BCZzaIMjBDvCRYhK+jgvJtCB8qOK+bhtWd8+mwxlwwrs+NDzc
         PHHXmfnjpJwfr1NWYApICM7E686faquzIzBx7KMugA4fHRpHukOKh8hd4yMclyBH+Vc7
         o/8b66p1ny9XjBUhFgkPksFeH3OOulO5azwfRiwULiotkZnLn+2SospipbKxTfxk83yl
         Qvls9NBFcEM3VMhqtN1cOmgzyKHHYmXj8gpjwhL2eiaXuc/+MYz+TR+WIOdeGEpyUEmq
         pLMQ==
X-Gm-Message-State: APuU4Z/CL/DODai/+6bA0xUXN2HMZXZbUF3hTSpUgSnRW5vIjRQD0wjN
	j09yeyjSy2z9rfciZqkcdgvib+hnKbqvPKX8mpJ8Y41909KQm692BBIToTj2lrBjKnv7EavU4vk
	mdAVvkw+DRmkZ/BpNvHewX5/zAWmezVT9/IdQcnVNUP0dEEBpFWhPdlGn1PJqNhh5uKhVK0SFKh
	BsCgt7uVK+EElZxmbKnkVClDX9EZ751Ak4NqVPpFG+k9NAr+Z31UYptC7FQ4q5rD1CZIOTJHBHL
	MUMYTrqqh6nIbXiogsng5V8Xc3pqt/VO6Y=
X-Gm-Gg: AZFdTZd7CPo1U+afKepiVEV31aOSs4wml6XHI3jZNKjy8VVlm/wLGM49aWuHYHYYwy+
	xenrqfVa2K9jH6ZuB6rLaDz48RS1A9kbjWBOk9G726ZjSULlblE8KoeorGU04ydMWBIi5Vbj99g
	joCqq2pawlENs+qpIzInlHWTCNd0cfcYBAktG6OWSULdvx9we4GlX0uaBqwAQw/m67A0ozU9PAO
	Wmvbew3t4XJbzlMyfjqN/iaYOn2JRcEnDFb3hSn9AH8wR7GCbKZCpuhpm2uGuim77mPKPmSkKHB
	rolkxPGS9yDi0AU/c4dMm/aNa+xQrPhEwmxpAH/fMjGgTS1V/vZixzkP2gGmC1W6f03MxWoUELA
	n3Ed1Bz1+yfBqZuI9UP718qgtRNIGmmayA6YyvIIZSRy42YCZhqCeFp+RINi0hN+BoOuWLCDjq2
	MDcqxcO4DmgkvNGhPItcB/UB4BiWOfuXoLKrXAlrIICaqMVF9KGxhRrawl
X-Received: by 2002:a17:90b:4b88:b0:3b1:ba59:56a1 with SMTP id 98e67ed59e1d1-3b3d07ca529mr2184296a91.39.1794996801120;
        Wed, 18 Nov 2026 02:13:21 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d0eaa8eesm1583775a91.2.2026.11.18.02.13.20
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:21 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2edd25534afso6871915ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996799; x=1795601599; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=F2ePSvYeiNUU5ptimEfx1WbPqwfjs2RpbUKuXWRqUhU=;
        b=VT4OglzlPV+n6BmgkHNfQHdCjMSL6EaO0Of+U70VAhU+uv6Xojvu0UKmbEYZVGClFd
         wMXsnTkjHL8WVn7b2hyjthx8EsdXUEmys+bT6xrlkhv5FPoWyBSbwKDc7BSHTOewQbFx
         v3zoOIHpm7MeR3ypDMMWL9qk/rlEgQcHMkUbo=
X-Received: by 2002:a17:90b:4fd1:b0:3a0:e4ce:31fd with SMTP id 98e67ed59e1d1-3b3d0765978mr2408272a91.10.1794996799414;
        Wed, 18 Nov 2026 02:13:19 -0800 (PST)
X-Received: by 2002:a17:90b:4fd1:b0:3a0:e4ce:31fd with SMTP id 98e67ed59e1d1-3b3d0765978mr2408233a91.10.1794996798873;
        Wed, 18 Nov 2026 02:13:18 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:18 -0800 (PST)
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
Subject: [PATCH v2 22/37] scsi: mpt3sas: Clamp num_luns in _scsih_wait_for_target_to_become_ready
Date: Wed, 18 Nov 2026 01:56:31 -0800
Message-Id: <1794995806-5835-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp num_luns to the lun_data allocation size before using it as a
loop bound.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8bafb8ea70a8..64de88183f8d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8187,6 +8187,8 @@ _scsih_wait_for_target_to_become_ready(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		(data[2] << 8) | (data[3] << 0));
 
 	num_luns = (length / sizeof(struct scsi_lun));
+	/* Clamp to last valid index: loop uses inclusive bound lun_data[num_luns] */
+	num_luns = min_t(u32, num_luns, MPT3_MAX_LUNS - 1);
 
 	lunp = &lun_data[1];
 	lun = (num_luns) ? mpt_scsilun_to_int(&lun_data[1]) : 0;
-- 
2.53.0

