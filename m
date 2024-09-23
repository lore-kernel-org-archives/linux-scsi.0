Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32A7199BC
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2024 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727115345; cv=none; b=gZtEfLH8SsevmIde7HyUM1MPh8wZHfNqogJrU91sFhBj8D4jU6ZYbZmhRCcULBsZb7+NvJ4E/GdoQe2qenwYLMH8zGg8qU4AVRH9/bFA1NKQ7HwxULO280ABfiyd91ebiaKEA/Y0YOdlyhJhrbuNZDAFA09rOTMgBPXvDzNTUG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727115345; c=relaxed/simple;
	bh=M5yJSXjsgwhBaZZG+eBdIU0l2uytCA9TtQucsW4kr3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SB++XM/f0lwk+dqzbaQ0yDGyawCBdeyqYR2S9C7tE8qhRYIWKX/UZGOFXAVPO2kJ/wCC1pVpmkl4qVscm896Nl8YuxhhPRdr9o+/q+5fAddE4+eAP7kjNYubDIwVLm4YeSSKJxFiO1c1501AnbrFahwHvdKog/N1lKErHgmh5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PiDo9uEE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PiDo9uEE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XCB4b2bp7z6ClY9Y;
	Mon, 23 Sep 2024 18:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727115334; x=1729707335; bh=CSN9wksjI0Zc9uZFbnMPMbYZ
	8Lq94uSxRXXykLs0YWc=; b=PiDo9uEEr0whAr7wXkNAKkjfUXi2phD+Vk7fuOuv
	mlp+xxk0sNUtyKrgz+GwmFTEpQTX91h/dFyh+2kNwporsPOotHI8t9ozpK6hYejr
	dbfgJMmNvzhD0erWi+OihrT1ZJgBKEEw441yXOKrsObSudsN9wSA54l1epCPH9vW
	nDMvG4vy44ewaNOic4cp3DD72DA94zqySzwxGbYkvlO9do9h5qD6vmqWKrXgIMiH
	STJ3wpeHpUtLpcZtEDn8B9DZIHT3AERnPoGGwJo/vzjNVAwUEeKQi9KuPcpjSUUL
	rH/wPcjzCEbiEXVf6mpvoabqfJBU6cxzzrqLYCO1qTYO4g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vMvZEHa-SM8i; Mon, 23 Sep 2024 18:15:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XCB4L1BmVz6ClY9X;
	Mon, 23 Sep 2024 18:15:29 +0000 (UTC)
Message-ID: <ce42d310-2a23-453f-bd14-71eeaf9f5664@acm.org>
Date: Mon, 23 Sep 2024 11:15:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/3] ufs: core: add a quirk for MediaTek SDB mode
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
References: <20240923080344.19084-1-peter.wang@mediatek.com>
 <20240923080344.19084-4-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240923080344.19084-4-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/24 1:03 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b5c7bc50a27e..b42079c3d634 100644
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
>   				"OCS aborted from controller = %x for tag %d\n",
>   				ocs, lrbp->task_tag);

I think the approach of this patch is racy: the cmd->result assignment
by ufshcd_transfer_rsp_status() races with the cmd->result assignment by
ufshcd_abort_one(). How about addressing this race as follows?
* In ufshcd_compl_one_cqe(), if the OCS_ABORTED status is encountered,
   set a completion.
* In the code that aborts SCSI commands, for MediaTek controllers only,
   wait for that completion (based on a quirk).
* Instead of introducing an if-statement in
   ufshcd_transfer_rsp_status(), rely on the cmd->result value assigned
   by ufshcd_abort_one().

Thanks,

Bart.

