Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795399693;
	b=EVZlxoY0orbslr5lIl2NMW5TfsDH1hKBviQ+z92cDx3yS9Zu0uimqzAVlF4mAUNAoh2w
	 IPUO5qmI5YDm0IJ6+DjsyWZfhFNhjYFnUiqaosa7a990ujMJ9lNdgHhmlx2/vN2EOs7+/
	 WsJ26+WXBpZwQFT9Zt1S0V+KWUkLh4xN3DwwqTqAD41TxYJp274MTmLkV5ffd+UKfM98C
	 /kMU9mFkj9LH7uT8lDGXYRBSDIAdqCi+3ZQe3MlBQgZETe/iw5RE4CCv+kFZDCICKLgxG
	 l8gDiA2ChuMpc429dynvTXFGx8mfhnoQ1L2ZdeZy9WymljAyK90+5hWJY2IEwRBfteQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795399693;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:
	 Thread-Index:Content-Language:X-CMS-MailID:X-Msg-Generator:
	 X-Sendblock-Type:CMS-TYPE:X-Hop-Count:X-CMS-RootMailID:References;
	bh=PLllFTcqAnbessRivwyu2sOX19waRtmxokz3I6FBG+g=;
	b=1WKqNZmHbVZ/seYyj2CujBmJKpq4LektWmrMWrxTx7xfbr3F/LN8kqllNl7oOm0ck/oN
	 sO6mnYvyTwvTWqc3+BScnvZCKuAMB66PpA9lZiKGKzZZQkZW0P2uUlX3v2AZOgnTViYLb
	 F/DnW6TASFPbmeTkiVP9eKz1qsyNgKhkrEfiM4/eCM5OU+pjZhlliXTKfFYAY+y5CHIkT
	 mgCVsOWr/McWcmgca6R4HoWerUNRH8t8nYTQdEp1T40mXwFkWtUtb7Rt13N7jBU2znGO1
	 cgLkbDxrz3izyTl9qhzxfHRnHiZ+NCPDYZLWTJZC43jzqhQblkwa057WnCTAVpIIHNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=kpoodrVQ;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52876606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 02:08:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52876606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=kpoodrVQ
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261123020802epoutp0371dc3a268eaa1b1dc16423f6cbe9baa0~qin_9akT13073630736epoutp03S
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 02:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261123020802epoutp0371dc3a268eaa1b1dc16423f6cbe9baa0~qin_9akT13073630736epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795399682;
	bh=PLllFTcqAnbessRivwyu2sOX19waRtmxokz3I6FBG+g=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=kpoodrVQtpeXpzR++ntubwf8tjIAuStPsn8lyqXuwt32Ukukq7YryS4YI/kHxMWpi
	 OEYaNGqNRGKUHyO7pN7hi5Eq6uWRuCroNdCsgINPM9Whbo244TsbSSplUzQl+484DA
	 fsPyUilVKU21KN5oCpTXERi/eXciVBovEqGlcokw=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261123020802epcas2p36f3fbc82fc988930adf76d4dbade9d97~qin_cS0zP3268932689epcas2p3M;
	Mon, 23 Nov 2026 02:08:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jXq8y0pFVz3hhT8; Mon, 23 Nov
	2026 02:08:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261123012546epcas2p4576e033739eda807de8a07a367b65478~qiDEfe4Q-1110211102epcas2p4Z;
	Mon, 23 Nov 2026 01:25:46 +0000 (GMT)
Received: from KORCO118546 (unknown [12.80.207.184]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20261123012545epsmtip230638475e4d7d84bf56d54f782744001~qiDEaozwY3219832198epsmtip2d;
	Mon, 23 Nov 2026 01:25:45 +0000 (GMT)
From: "hoyoung seo" <hy50.seo@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, "'Martin K . Petersen'"
	<martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>, "'James E.J. Bottomley'"
	<James.Bottomley@HansenPartnership.com>, "'Martin K.	Petersen'"
	<mkp@kernel.org>, "'Peter Wang'" <peter.wang@mediatek.com>, "'Bean Huo'"
	<beanhuo@micron.com>, "'Stanley Jhu'" <stanleyjhu@google.com>, "'Can Guo'"
	<can.guo@oss.qualcomm.com>, "'John Garry'" <john.garry@linux.dev>,
	"'Hyeoncheol Jeong'" <hyenc.jeong@samsung.com>, <cpgsproxy1@samsung.com>
In-Reply-To: <cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
Subject: RE: [PATCH] ufs: core: Remove the DMA addresses from struct
 ufshcd_lrb
Date: Mon, 23 Nov 2026 10:25:45 +0900
Message-ID: <1860250540.01795399682092.JavaMail.epsvc@epcpadp2new>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIrDO0P8eaXA+K6KmZwGYWJ4lk6hQMIIvdXtod3kZA=
Content-Language: ko
X-CMS-MailID: 20261123012546epcas2p4576e033739eda807de8a07a367b65478
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261120005128epcas2p236aa8583f2847df64974267f9a760773
References: <CGME20261120005128epcas2p236aa8583f2847df64974267f9a760773@epcas2p2.samsung.com>
	<cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>

Reviewed-by: HOYOUNG SEO <hy50.seo@samsung.com>

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Friday, November 20, 2026 9:51 AM
> To: Martin K . Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; Bart Van Assche <bvanassche@acm.org>;
> James E.J. Bottomley <James.Bottomley@HansenPartnership.com>; Martin K.
> Petersen <mkp@kernel.org>; Peter Wang <peter.wang@mediatek.com>; Bean Huo
> <beanhuo@micron.com>; Stanley Jhu <stanleyjhu@google.com>; Can Guo
> <can.guo@oss.qualcomm.com>; HOYOUNG SEO <hy50.seo@samsung.com>; John Garry
> <john.garry@linux.dev>; Hyeoncheol Jeong <hyenc.jeong@samsung.com>
> Subject: [PATCH] ufs: core: Remove the DMA addresses from struct
> ufshcd_lrb
> 
> The offsets stored in struct utp_transfer_req_desc are in double words on
> hosts without UFSHCD_QUIRK_PRDT_BYTE_GRAN. Using these offsets as byte
> offsets to compute ucd_rsp_dma_addr and ucd_prdt_dma_addr results in
> incorrect DMA addresses. These addresses are only used by
> ufshcd_print_tr() for error logging.
> 
> Instead of fixing how these addresses are computed, remove the
> utrd_dma_addr, ucd_req_dma_addr, ucd_rsp_dma_addr and ucd_prdt_dma_addr
> members from struct ufshcd_lrb and do not report DMA addresses anymore in
> ufshcd_print_tr(). The contents of the transfer request descriptor, the
> request UPIU, the response UPIU and the PRDT are still dumped by that
> function. Remove the local variable cmd_desc_element_addr from
> ufshcd_init_lrb() since it is no longer used.
> 
> This patch changes the output of ufshcd_print_tr() as follows: the
> "Transfer Request Descriptor phys@", "Request UPIU phys@" and "Response
> UPIU phys@" lines are no longer logged and the "PRDT" line no longer
> includes a physical address.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 23 +----------------------
>  include/ufs/ufshcd.h      |  9 ---------
>  2 files changed, 1 insertion(+), 31 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 56a77f4a2a6e..839d62aebe8a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -614,18 +614,11 @@ static void ufshcd_print_tr(struct ufs_hba *hba,
> struct scsi_cmnd *cmd,
>  		dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n", tag,
>  			div_u64(lrbp->compl_time_stamp_local_clock, 1000));
>  	}
> -	dev_err(hba->dev,
> -		"UPIU[%d] - Transfer Request Descriptor phys@0x%llx\n",
> -		tag, (u64)lrbp->utrd_dma_addr);
> 
>  	ufshcd_hex_dump("UPIU TRD: ", lrbp->utr_descriptor_ptr,
>  			sizeof(struct utp_transfer_req_desc));
> -	dev_err(hba->dev, "UPIU[%d] - Request UPIU phys@0x%llx\n", tag,
> -		(u64)lrbp->ucd_req_dma_addr);
>  	ufshcd_hex_dump("UPIU REQ: ", lrbp->ucd_req_ptr,
>  			sizeof(struct utp_upiu_req));
> -	dev_err(hba->dev, "UPIU[%d] - Response UPIU phys@0x%llx\n", tag,
> -		(u64)lrbp->ucd_rsp_dma_addr);
>  	ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
>  			sizeof(struct utp_upiu_rsp));
> 
> @@ -634,10 +627,7 @@ static void ufshcd_print_tr(struct ufs_hba *hba,
> struct scsi_cmnd *cmd,
>  	if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
>  		prdt_length /= ufshcd_sg_entry_size(hba);
> 
> -	dev_err(hba->dev,
> -		"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
> -		tag, prdt_length,
> -		(u64)lrbp->ucd_prdt_dma_addr);
> +	dev_err(hba->dev, "UPIU[%d] - PRDT - %d entries\n", tag,
> prdt_length);
> 
>  	if (pr_prdt)
>  		ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr, @@ -
> 2983,17 +2973,13 @@ static void ufshcd_init_lrb(struct ufs_hba *hba,
> struct scsi_cmnd *cmd)  {
>  	const int i = scsi_cmd_to_rq(cmd)->tag;
>  	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
> -	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
> -	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
>  	struct ufshcd_lrb *lrb = scsi_cmd_priv(cmd);
>  	u8 *command_upiu, *response_upiu, *prd_table;
> -	dma_addr_t cmd_desc_element_addr;
> 
>  	/* The reserved tag uses a dedicated UCD outside the pool. */
>  	if (unlikely(blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))) {
>  		struct utp_devman_cmd_desc *cmd_descp = hba-
> >devman_ucd_base_addr;
> 
> -		cmd_desc_element_addr = hba->devman_ucd_dma_addr;
>  		command_upiu = cmd_descp->command_upiu;
>  		response_upiu = cmd_descp->response_upiu;
>  		prd_table = cmd_descp->prd_table;
> @@ -3005,22 +2991,15 @@ static void ufshcd_init_lrb(struct ufs_hba *hba,
> struct scsi_cmnd *cmd)
>  		WARN_ON_ONCE(slot < 0);
>  		cmd_descp = (void *)hba->ucdl_base_addr + slot *
> ufshcd_get_ucd_size(hba);
> 
> -		cmd_desc_element_addr =
> -			hba->ucdl_dma_addr + slot *
ufshcd_get_ucd_size(hba);
>  		command_upiu = cmd_descp->command_upiu;
>  		response_upiu = cmd_descp->response_upiu;
>  		prd_table = cmd_descp->prd_table;
>  	}
> 
>  	lrb->utr_descriptor_ptr = utrdlp + i;
> -	lrb->utrd_dma_addr =
> -		hba->utrdl_dma_addr + i * sizeof(struct
> utp_transfer_req_desc);
>  	lrb->ucd_req_ptr = (struct utp_upiu_req *)command_upiu;
> -	lrb->ucd_req_dma_addr = cmd_desc_element_addr;
>  	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)response_upiu;
> -	lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
>  	lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)prd_table;
> -	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
>  }
> 
>  static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct scsi_cmnd
*cmd,
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> be62165b785e..4465e06fd394 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -157,10 +157,6 @@ struct ufs_pm_lvl_states {
>   * @ucd_req_ptr: UCD address of the command
>   * @ucd_rsp_ptr: Response UPIU address for this command
>   * @ucd_prdt_ptr: PRDT address of the command
> - * @utrd_dma_addr: UTRD dma address for debug
> - * @ucd_prdt_dma_addr: PRDT dma address for debug
> - * @ucd_rsp_dma_addr: UPIU response dma address for debug
> - * @ucd_req_dma_addr: UPIU request dma address for debug
>   * @scsi_status: SCSI status of the command
>   * @command_type: SCSI, UFS, Query.
>   * @lun: LUN of the command
> @@ -179,11 +175,6 @@ struct ufshcd_lrb {
>  	struct utp_upiu_rsp *ucd_rsp_ptr;
>  	struct ufshcd_sg_entry *ucd_prdt_ptr;
> 
> -	dma_addr_t utrd_dma_addr;
> -	dma_addr_t ucd_req_dma_addr;
> -	dma_addr_t ucd_rsp_dma_addr;
> -	dma_addr_t ucd_prdt_dma_addr;
> -
>  	int scsi_status;
> 
>  	int command_type;


