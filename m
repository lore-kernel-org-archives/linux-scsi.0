Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793265506;
	b=RgVc0fcX8HtH0BTF6cqnVeMT096FkyQWs39WjOrImXjEBMpFfw6aDlmaWWtAfa35TYO5
	 Fmf/zdOCwtDaw1l/ntkrbyVeMN61CwLE++2esvWRE3huwz0Og2vkyIAH4vCqnnRNkipln
	 dwtr856UIP6xkZidqH3yiuAUqk8Ep12DNYO99u53QTrZcsIvp18SR3F2TC5AWjx8zqEDx
	 TTmpQl4ITXmfY1Pxs19eyHVSccdBh53MFdsUZHoKOlBoCwEsAnlNO8X6AcmVw3f0rSsgf
	 mr5OnbBHVoeKHb3+SAECzRAuoRue0M9cOmRO/aizEsABiZarkIlniYqXxxfxjok8Iqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793265506;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=WbpvsXKX9ms2sT+M7ciSC2XkOBju1VKOi1MohxOALLA=;
	b=WMjzkpaVPxR7kTMMP7hawTfAz4KhhNAhDNPnRVGbFx+S7/tuPKdMfYqUJ25yWtMz1tr6
	 u1Z8lx2jC3xp4hcekv+HrpVJRmu6S3TNPaR7a6gA4y5bJXaW2dQ/mlOl185DkaN34ti22
	 MfYRmqLejCNEFPXF79OzCur+1n+5NGCsENBbsnyTC6ptjT1yPIij9MpE04Bw2W/j9ndCn
	 HULHKX0XWbN9WSbfTPSCtfmR57keBp9R8aExaaex8WUASJr2y0cbTSqq75D/asLDS7qm1
	 39d0E9zPa4W9sConfdZF7sJNXVGISNFwxg3KuabMzgf5YjF+uIlMFRKjvO6z937mJCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=M2kWZvRZ;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E5A606A31A;
	Thu, 29 Oct 2026 09:18:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03E5A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=M2kWZvRZ
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WbpvsXKX9ms2sT+M7ciSC2XkOBju1VKOi1MohxOALLA=;
	b=M2kWZvRZGEw73IWLSODipFlx8eZFPOXiXaj366REFXsYD04K87D4R0lxfN0aL5NrQin4b1Cx7
	FSqaz991cw+xwymDPUg1xM3DM61ltgmF8WmhfTFZ1N7EFAcIl9ycWJw1Ly3AvMeY5IVhdOvnPa+
	HxrdSVSgtd+ur2DMAfne5IU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jFdtg6ZCMz1cyQr;
	Thu, 29 Oct 2026 17:18:03 +0800 (CST)
Received: from dggpemr200001.china.huawei.com (unknown [7.185.36.96])
	by mail.maildlp.com (Postfix) with ESMTPS id 521974057C;
	Thu, 29 Oct 2026 17:18:11 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr200001.china.huawei.com
 (7.185.36.96) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 29 Oct
 2026 17:18:10 +0800
From: Ran Hongyun <ranhongyun1@huawei.com>
To: <sanan.hasanou@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<mkp@kernel.org>, <sanan.hasanov@ucf.edu>,
	<syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com>,
	<target-devel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: Re: [PATCH v4 1/4] scsi: target: rd: Fix oversized sg table array allocation
Date: Thu, 29 Oct 2026 17:10:24 +0800
Message-ID: <20261029091024.134838-1-ranhongyun1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261009003537.62265-2-sanan.hasanou@gmail.com>
References: <20261009003537.62265-2-sanan.hasanou@gmail.com>
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
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemr200001.china.huawei.com (7.185.36.96)

Hi Sanan,

Thanks for the patch. One question about rd_build_prot_space():

The totalram_pages() check is only added in rd_build_device_space(), but
rd_build_prot_space() is also reachable with an inflated rd_page_count
that exceeds totalram_pages(), via:

  1. echo "rd_pages=1024" > control   (valid value)
  2. echo 1 > enable                   (rd_build_device_space succeeds,
                                        DF_CONFIGURED set)
  3. echo "rd_pages=-1" > control      (rd_page_count overwritten to
                                        UINT_MAX, no configured check in
                                        target_dev_control_store)
  4. echo 1 > pi_prot_type             (triggers rd_build_prot_space with
                                        the tampered rd_page_count)

In step 4, rd_build_prot_space() proceeds with the impossible page count
and attempts alloc_pages(), failing mid-way with -ENOMEM.

Should rd_build_prot_space() also get the totalram_pages() check to
reject impossible values early?

Thanks,
Ran Hongyun

