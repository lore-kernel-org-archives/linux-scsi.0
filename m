Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06C71422B8
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 08:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719563887; cv=none; b=YRz4ix58Ajfjg6QKRLcI9fW5uSQNEMbLW5ajsKXt52jrahoSGVWKTbcPd4n58Q0jBpUwRSQMN8u59qGNJggCryeP391tZg9x+1N+dIakckkG+j/Ct3vRIo2mYEgZo4VzXTW0AwkXlR962BXayMJj+QvjVyu7M+nH7jPnron/h28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719563887; c=relaxed/simple;
	bh=u3WNXiTYKdqUXwGDamx1xHy+lOP8jmOOqssZbuqqlgw=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=PXn/hjLa/1+arkKQ25+uOih/pCRIiO7xNOeOYAuIsbba7ghg0kIZZjJgWI90YcL78aSmOKRdKvtIpdfshCdFe54rjzJ7bEFl5VNgC0av2Tp8BDKb6tHtI3yo0EeL67Hcz2opQvtX8swnr44TRfY2eZ44HQS0yGFmF8DtxR9VQLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Hnz9ixBL; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Hnz9ixBL"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240628083802epoutp02558f2e36acf93cc0976f7f806a9719d9~dHj2ISXY-1044810448epoutp02e
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 08:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240628083802epoutp02558f2e36acf93cc0976f7f806a9719d9~dHj2ISXY-1044810448epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719563882;
	bh=aSTfbz9JlnDfcs3TArSXBFru32/Q02izM/pPL09Ia9g=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=Hnz9ixBLFy7H7TpEtUKARzQlWxioDFWyU+BlGNSV3TKOTtSBl0uypN50cKQjGT/Ku
	 R6eGptqsoxETFbaPuc7g9uNVv7wJjEsRQPPD6t0FbArQOttu3XAoI5rZKyP0d0Fka7
	 0HlslQvs0sCAT14h7XA7yrMfZhuU/YnpnNf98JjU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240628083801epcas2p4ef9cfb8cdd54afe88516ddc094e0114c~dHj1dr1nf2101521015epcas2p4M;
	Fri, 28 Jun 2024 08:38:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
	(Postfix) with ESMTP id 4W9TN9483cz4x9Q8; Fri, 28 Jun 2024 08:38:01 +0000
	(GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH v2 3/7] scsi: ufs: Remove two constants
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Manivannan
	Sadhasivam <manivannan.sadhasivam@linaro.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240627195918.2709502-4-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01719563881553.JavaMail.epsvc@epcpadp4>
Date: Fri, 28 Jun 2024 12:14:58 +0900
X-CMS-MailID: 20240628031458epcms2p6128fb700d56d1dbff493d6ba1d20fece
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20240627200046epcas2p254b6b6b311100539489e353b3f74ef10
References: <20240627195918.2709502-4-bvanassche@acm.org>
	<20240627195918.2709502-1-bvanassche@acm.org>
	<CGME20240627200046epcas2p254b6b6b311100539489e353b3f74ef10@epcms2p6>

> The SCSI host template members .cmd_per_lun and .can_queue are copied
> into the SCSI host data structure. Before these are used, these are
> overwritten by ufshcd_init(). Hence, this patch does not change any
> functionality.
> 
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong

> ---
>  drivers/ufs/core/ufshcd.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b7ceedba4f93..9a0697556953 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -164,8 +164,6 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
>  enum {
>  	UFSHCD_MAX_CHANNEL	= 0,
>  	UFSHCD_MAX_ID		= 1,
> -	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
> -	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
>  };
>  
>  static const char *const ufshcd_state_name[] = {
> @@ -8958,8 +8956,6 @@ static const struct scsi_host_template ufshcd_driver_template = {
>  	.eh_timed_out		= ufshcd_eh_timed_out,
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
> -	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
> -	.can_queue		= UFSHCD_CAN_QUEUE,
>  	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
>  	.max_sectors		= SZ_1M / SECTOR_SIZE,
>  	.max_host_blocked	= 1,
