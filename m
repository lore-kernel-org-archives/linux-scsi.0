Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795495334;
	b=1cZ0sSKaa7CDuhJVcfIKHDGqA9de9of2lF6zmV4nSZhIbcBAs3DdQmHEfYMTgeeYRXLx
	 ejILUnU4/RJ5pF+uZpj+/0QPc2mjFYXTzwDU/j3jbUG5ElkhJNQsC2KAmlCbcdlTkigVg
	 KAwAB9C7y1q/s4AvL7kVf3AO3tFXFV1EzrmXSByvxlnv2UyCZw4AYXOrEZ9tR6bBJ40Cz
	 HWv/8Azqrl/gM38h1kfNWKRap9Nj03bcmXvr3VIFly5HfcO8tloGhp6qugnlzcv7tvZSq
	 5RgQdlRvJ5lxvRaiHYpW6KYNWgziTPZym/jgS1uPLM0Lni0JRwChRNIySTG0hDNTdSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795495334;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UsLmvKAgrJUY2cpohL8JirbNaDQBIx+GINcdwhDCGH8=;
	b=Cps0WUsoi9Kp/zrV7V9t7lOrWRiqUzHd/j3qnThdFbQ3soJF39LFamgKyQULwfTJfFhC
	 HUnTQdQtyo+ESqXGPhoGcg0AlmVQe53RmNbc01eFNotPZBm3/q7i0ilQgPV+PXQeqq/IP
	 FTHKD4UECgU+vGCHTSTN2D6dRTfG87L1clxwq9ghgdxXd17CttW5IJMxu2tYMu2ARG3ku
	 qTsM17CHTxURKeZLH4uR4ZHAWCBNllft5s7bQB9T/4HhdFuyCeQUrbggmX2Z9u4ttwSUv
	 oQyg8dR8TuMvO98vCgh/Et8BfQztE9JThuQM+YoK6sjRXzuRHAyVsAI8qj6Iwi+QgJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=dZfkrPDM;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7179B606A321;
	Tue, 24 Nov 2026 04:42:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7179B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=dZfkrPDM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=dZfkrPDMovmIRE7bnduyFwyIfVuYHGym+FgNFDlGKm28NFYpM6ryxJYMeWXTPWM2gzYfF+YLSoHdA
	 6mALJAJoL73OfH3OB+ldvoEOSKrOguQsi6ddinE6/vo3dDMZdQVljTJyZMuT9NPWJDkv+pyPkdbwJc
	 2gC9Jvw2GOt9b4+c=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66b05159d1b7-106f0;
	Tue, 24 Nov 2026 12:42:11 +0800 (CST)
X-RM-TRANSID:2ee66b05159d1b7-106f0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from DESKTOP-3K8GUTQ (unknown[223.108.79.98])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36b05159f5d7-13783;
	Tue, 24 Nov 2026 12:42:11 +0800 (CST)
X-RM-TRANSID:2ee36b05159f5d7-13783
From: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
To: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>,
	Orson Zhai <orsonzhai@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-sprd: Fix vdd-mphy regulator leak on probe failure and remove
Date: Tue, 24 Nov 2026 12:42:09 +0800
Message-ID: <20261124023200.1280-1-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261110065457.1280-1-laixiangwu@cmss.chinamobile.com>
References: <20261110065457.1280-1-laixiangwu@cmss.chinamobile.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Martin, James,

A gentle ping on this patch, sent two weeks ago on Nov 10:

  scsi: ufs: ufs-sprd: Fix vdd-mphy regulator leak on probe failure and remove
  https://lore.kernel.org/all/20261110065457.1280-1-laixiangwu@cmss.chinamobile.com/

The patch adds the missing .exit callback to the ufs-sprd host driver so
that the vdd-mphy regulator enabled in .init is released when the probe
fails after ufshcd_pltfrm_init() or when the host is later removed --
currently both paths leave the regulator enabled forever.

Please let me know if anything else is needed.

Thanks,
Xiangwu Lai


