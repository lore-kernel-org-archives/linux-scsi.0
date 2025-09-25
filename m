Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144C730BF79
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758820996; cv=none; b=hzRG4D6BEU/5fpKIEDmsTgsRxTpmFcsAPVs3ErEe9185+uiL4l+aw0+fmBJKIVOCARVJieSLTjPrBIwnV9gFDDad/xbmUtBRP9VCZIN0Pmj5OQR4bIJhb89mNdHfFStF/394NOdW7TkU3QbO7uVVsxwF6psoOj0qp7Hk8Moami4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758820996; c=relaxed/simple;
	bh=qWVXhderdwzhwj5vUlHKhzn+3gXZQ/G0dJq0esuJVGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I+os4qNu35LyJq09EwQ3hYthPMuDaALTrntJ1q/ZDudj+6iJ7K4g8YiO6MqeVeQn4bJXtWrQPpYf3M1w9JzlwWMfjGPLYGMCf23pwfCPEn37MZW3KJ9UedzwVoWRstuIomH+rTBgkOpBhuRcvUmTBEp7VjPcZDEiBjCVLcqBkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=e6yVtL5Q; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="e6yVtL5Q"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id 1bHAv5TcCZx2i1pgXvuyGX; Thu, 25 Sep 2025 17:23:13 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 1pgVvFMNYBc9y1pgVv0DyB; Thu, 25 Sep 2025 17:23:11 +0000
X-Authority-Analysis: v=2.4 cv=ZcMdNtVA c=1 sm=1 tr=0 ts=68d57a7f
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=kbmabLdzh3uUJaiPGAIkPw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7T7KSl7uo7wA:10 a=20KFwNOVAAAA:8
 a=mdcTwAhxuRZp_wTR5vIA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gpNl6QTJT5Qsxrumjuau4ijF3CrN0biir9a3RwmFtTg=; b=e6yVtL5Q4BgeXdy0385Xw8Xi9I
	gT2TgH3h4qALRO4uCHi6jqE2AWLJsBsGQ2DhJz4VhUQZLx3YHljfuzV4qnFUzMC0Yp9KY9YRmHU+T
	fLFSvoSQo/+g9NXsLsl8NPU0wAw8b0aIyarLbV7fdwrfO+g068WCkJsNOpXIRagOQ5HBuiifVTl/k
	ImNZ2XnuMgSjlKQjeav9cAS2N1qWCxVs6OZdEwC4gY8mLl8nuZkupz7Srr4aTQTgLggF9O+bUBRrl
	+NkB9akLsZqaLE7211hNjOYdjNffb81ePCivHJ+HYVgZXe+ddToiF2yml4BAdGicZd+AoJKOVorVi
	tRJtTzsA==;
Received: from [83.214.221.223] (port=33030 helo=[192.168.1.104])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v1pgU-00000003CnH-1zXK;
	Thu, 25 Sep 2025 12:23:10 -0500
Message-ID: <e58d743b-a999-4e00-8f2e-31707744c5bb@embeddedor.com>
Date: Thu, 25 Sep 2025 19:22:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: qla2xxx: zero default_item last in
 qla24xx_free_purex_item
To: Bryan Gurney <bgurney@redhat.com>, jmeneghi@redhat.com,
 linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, hare@suse.de, linux-hardening@vger.kernel.org,
 kees@kernel.org, gustavoars@kernel.org, emilne@redhat.com
References: <fbbef12e-fc43-464f-b92d-f42f3692a46c@redhat.com>
 <20250925170223.18238-1-bgurney@redhat.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20250925170223.18238-1-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 83.214.221.223
X-Source-L: No
X-Exim-ID: 1v1pgU-00000003CnH-1zXK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.104]) [83.214.221.223]:33030
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKmRZLlh5TJgqiLQWblXBMX4FUdMf/d1EaTm6NOEc3QUljuNBMiLVCZoPs+SJLpcPceZYlLlC9+6ZkU8cz13WYsjvUsBWMpzNFD/WRCezhh8rBu3mmqJ
 /5SLyPXkWKxifveWIPFLghckTKgXx+7lvVaunqPY+Cws3opajwrmsIqPOpVQJ3UI9FaZETo2HDqQXiIjCR4VePzeH6gzZs1EbPSeeWtSu1coJsumZE1BjpGN



On 9/25/25 19:02, Bryan Gurney wrote:
> In order to avoid a null pointer dereference, the vha->default_item
> should be set to 0 last if the item pointer passed to the function
> matches.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000936
> ...
> RIP: 0010:qla24xx_free_purex_item+0x5e/0x90 [qla2xxx]
> ...
> Call Trace:
>   <TASK>
>   qla24xx_process_purex_list+0xda/0x110 [qla2xxx]
>   qla2x00_do_dpc+0x8ac/0xab0 [qla2xxx]
>   ? __pfx_qla2x00_do_dpc+0x10/0x10 [qla2xxx]
>   kthread+0xf9/0x240
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0xf1/0x110
>   ? __pfx_kthread+0x10/0x10
> 
> Also use a local variable to avoid multiple de-referencing of the item.
> 
> Fixes: 6f4b10226b6b ("scsi: qla2xxx: Fix memcpy() field-spanning write issue")
> Signed-off-by: Bryan Gurney <bgurney@redhat.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 98a5c105fdfd..7e28c7e9aa60 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -6459,9 +6459,11 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
>   void
>   qla24xx_free_purex_item(struct purex_item *item)
>   {
> -	if (item == &item->vha->default_item) {
> -		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
> -		memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
> +	scsi_qla_host_t *base_vha = item->vha;
> +
> +	if (item == &base_vha->default_item) {
> +		memset(&base_vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
> +		memset(&base_vha->default_item, 0, sizeof(struct purex_item));
>   	} else
>   		kfree(item);
>   }

I see. I think it's probably better to go ahead with the revert, and then apply
the patch I proposed in my previous e-mail (it's more straightforward and introduces
fewer changes).

If you agree with that, I can submit both the revert and the patch.

Thanks
-Gustavo

