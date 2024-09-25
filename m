Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8062A134BD
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727283392; cv=none; b=MkL5/RuMRR+UV9r+WAxSArnO9ZPCR/hT70SziZj4VTDZhNl0Mmt5Qc6A2MjY/D2D8WCIkUpIc0VKk553TQzq51QU2EkqI5d98n034PHBYFCriOYGWuzHGUQjXf+Bo9cE7ri/cmERBp7fSRcAVFz7ObBGbPHqxjeQEukIwTiKNBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727283392; c=relaxed/simple;
	bh=8LfVU+3vKBBRvTpUQYOHOe6v/yO7i4HkllNTLYLxIOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ryGhtRdvgo9ZzIxY/xaG73UWxED5hPFILp4A2O+Gt7cldL24kBr1U7hp0NtoDMxF6Q5QvktIa0kU+ai0jYDsvzD6Gcrw2lKT8xQp66ghPCp3CXT4RWWYbf441CXbs/5xWAjI1J9zDDlz/ZcrepVaYMkT6pXpXXsK1/YhF04RHBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=knUhiyHL; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="knUhiyHL"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XDNDF5ffhzlgTWQ;
	Wed, 25 Sep 2024 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727283380; x=1729875381; bh=W1uARAEtCZ8e6OEALGT3Y0Ul
	/ZUS/KuncBTF6dONDlI=; b=knUhiyHLVbFzyYlAwrAT6d8/3aeP5MhmDlNCPNdn
	h7qhOz8b9M9+Ye7ofQa/bSObAG79D/TtWhmP4u/cJxB97P4F9qbo51VBx7x2v2I/
	7O/jXpIYAiGYl80StA3EIxUEHP7Udjg3mR5jCcVN9ds1OtludtxRkJKH+/wDVT8m
	9WKXqKbc1ri4qIdHUlW/Oklfa9082LMGeUfYxg5h0mqmxGEl0G16WLVqqRB5A91D
	IhnLZvpSmu7v0jmKFRYFTq4iQgi1EywILGwQA6D9Gv++orCFNwnton1674/vXDz+
	JFTYvX74BTUt8o5Ac1NVMyBJeVjFW4qg9ad5RSscDqFR+A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CGrYvXZT-pvp; Wed, 25 Sep 2024 16:56:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XDNCz56jPzlgTWK;
	Wed, 25 Sep 2024 16:56:15 +0000 (UTC)
Message-ID: <03b34628-d70b-4ce6-ad87-3c2070105bfa@acm.org>
Date: Wed, 25 Sep 2024 09:56:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com
References: <20240925095546.19492-1-peter.wang@mediatek.com>
 <20240925095546.19492-4-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240925095546.19492-4-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/24 2:55 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Because the MediaTek UFS controller uses UTRLCLR to clear commands
> and fills the OCS with ABORTED, this patch introduces a quirk to
> treat ABORTED as INVALID_OCS_VALUE.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c       | 5 ++++-
>   drivers/ufs/host/ufs-mediatek.c | 1 +
>   include/ufs/ufshcd.h            | 6 ++++++
>   3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4fff929b70d6..d429817fca94 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5404,7 +5404,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>   		}
>   		break;
>   	case OCS_ABORTED:
> -		result |= DID_ABORT << 16;
> +		if (hba->quirks & UFSHCD_QUIRK_OCS_ABORTED)
> +			result |= DID_REQUEUE << 16;
> +		else
> +			result |= DID_ABORT << 16;
>   		dev_warn(hba->dev,
>   				"OCS aborted from controller for tag %d\n",
>   				lrbp->task_tag);
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index 02c9064284e1..8a4c1b8f5a26 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1021,6 +1021,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>   	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
>   	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_INTR;
>   	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_RTC;
> +	hba->quirks |= UFSHCD_QUIRK_OCS_ABORTED;
>   	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
>   
>   	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 0fd2aebac728..8f156803d703 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -684,6 +684,12 @@ enum ufshcd_quirks {
>   	 * single doorbell mode.
>   	 */
>   	UFSHCD_QUIRK_BROKEN_LSDBS_CAP			= 1 << 25,
> +
> +	/*
> +	 * Some host controllers set OCS_ABORTED after UTRLCLR (SDB mode),
> +	 * this quirk is set to treat OCS: ABORTED as INVALID_OCS_VALUE
> +	 */
> +	UFSHCD_QUIRK_OCS_ABORTED			= 1 << 26,
>   };
>   
>   enum ufshcd_caps {

ufshcd_transfer_rsp_status() only has one caller, namely 
ufshcd_compl_one_cqe(). The previous patch makes sure that that 
ufshcd_compl_one_cqe() is not called if a SCSI command is aborted. So
why does this patch modify how OCS_ABORTED is processed? Is this patch
necessary or can it perhaps be dropped?

Thanks,

Bart.
