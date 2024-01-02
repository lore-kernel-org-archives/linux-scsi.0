Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F52020E0;
	Tue,  2 Jan 2024 03:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0yxUKDia"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=jPtuUmC93Yea48T6TTFZ4KmQu493//SKPkPtQ7A9VWM=; b=0yxUKDiaV3c/muWhadgd5rj+rS
	+xOoSFfSXoi9ElsyNcJPD0yiyavFaHdlIgSAvC0EBCnxrOTWB2EJlJTXXbKeLylzobnJBii78mZpt
	/wR4/X3eFyf1+zN6HKQR1ZT58ng2cTumpext5jnRXnVZJwO4HSGfgyuyxPJ6ji9GPhmGLr5v8vT6K
	K6hd8qxm33R7LehxYNFaXfsAL7x+TZ8SjwK0rWimroEwhRF86ae5ma4mj8n3s5TKzsVE8qUo4UUKa
	pBrXT2Fg/S21z3c90lQx8CJep/lLZgP9XRv7djcKGKcPs9pnF5lDIFWGZ/oSVSPHz4FRttiS4aUC/
	RlTNjFig==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKVjG-0072Fo-1F;
	Tue, 02 Jan 2024 03:46:10 +0000
Message-ID: <8b0ad2bb-df2e-4f0c-940c-e2cfbc8fa207@infradead.org>
Date: Mon, 1 Jan 2024 19:46:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] scsi: qedf: fix spelling typo in comment
Content-Language: en-US
To: zheng tan <tanzheng@kylinos.cn>, skashyap@marvell.com,
 jhasan@marvell.com, GR-QLogic-Storage-Upstream@marvell.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 k2ci <kernel-bot@kylinos.cn>
References: <20240102022448.3970501-1-tanzheng@kylinos.cn>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240102022448.3970501-1-tanzheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/1/24 18:24, zheng tan wrote:
> From: Zheng tan <tanzheng@kylinos.cn> 
> 
> fix spelling typo in comment.
> 
> Reported-by: k2ci <kernel-bot@kylinos.cn>
> Signed-off-by: Zheng tan <tanzheng@kylinos.cn>
> ---
>  drivers/scsi/qedf/qedf_hsi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_hsi.h b/drivers/scsi/qedf/qedf_hsi.h
> index ecd5cb53b750..2df2165e4356 100644
> --- a/drivers/scsi/qedf/qedf_hsi.h
> +++ b/drivers/scsi/qedf/qedf_hsi.h
> @@ -300,7 +300,7 @@ struct fcoe_respqe {
>  /* PARAM that is located in the FCP_RSP FC header */
>  #define FCOE_RESPQE_PARAM_MASK            0xFFFFFF
>  #define FCOE_RESPQE_PARAM_SHIFT           0
> -/* Indication whther its Target-auto-rsp mode or not */
> +/* Indication wether its Target-auto-rsp mode or not */

                 whether

>  #define FCOE_RESPQE_TARGET_AUTO_RSP_MASK  0xFF
>  #define FCOE_RESPQE_TARGET_AUTO_RSP_SHIFT 24
>  };

-- 
#Randy
