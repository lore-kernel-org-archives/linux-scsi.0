Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911ED253B42
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 19:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753731810; cv=none; b=cHeVtZsaCy/wIg3wHhUFyQpWeAuo8wnxSQWfCPM5hvoKot0T9wNrFRihZJaXuaiHXIiFiRwxloZyISKavJGBxCTxq7t6uM0NmwLpos12nqTsVbyqXxpMj3a85l2ek9PjsdTW2nIwxukSJ8jZ5Ya6WO5xj7+cA3QYRhgmlfGU3aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753731810; c=relaxed/simple;
	bh=NQAJKRJtopM+xP0JHCXnKw8Fu6twOUPOOQFSkAedptI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V78Hvi3yv06r2NjXoa1ov1zYvN7s/pH67AWZ8tKd55MjLiYf6DtliRgn9MsWWGQ93G37owuCOLGKQTDKYHeug9fpti8reFmRah9MIRWEdxN9Sp0C9JxM4TNF3DYV34zcWsoVbRSA+D159reOarXruXOGF5kw8BLCydY2h8C4ApQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=wUcCHTEh; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="wUcCHTEh"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id gQdUur5a75wATgTkmuCwhA; Mon, 28 Jul 2025 19:43:21 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id gTklumjBGxdA0gTkmuL7Vq; Mon, 28 Jul 2025 19:43:20 +0000
X-Authority-Analysis: v=2.4 cv=M9GGKDws c=1 sm=1 tr=0 ts=6887d2d8
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=elAakMZAzsQyfqpwiXQzJA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=_Fk7BiAtONcWSwObfToA:9 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bXMs1Y0vk9nAK2XAfY0ttwUxl9WnY4gyYt54ezdPO+c=; b=wUcCHTEhc03WUw3KXgVu53RDZl
	gWyPOlOm38Ar7asOblrnrToLgIOqLDRlCotVnuaz9gij8c5RX8S4FCYDrWZOPXiq3RRW3o7OMHNLk
	2URSJKPNj9IcSAf7NXU/uAph2IlTzYNKodwnpZUNI2b7tO3HWBeFtm5Lg9Ol3KSCxe+kSWjQtIdn3
	autRShVNgPpKlOQmSlRaGU1R/Ck9gepHbPepzCfr+1pGnHIyR51goVY3iOgb2TwgsSe8cQwycQc7N
	dDFGUpZ0+xpOLsXJhyD47fT3Jh6wCBqOPviqFi1qzNVltGNOsgVRMRvsKviBcC0/0wgtnF/6pNd/K
	HVTRk5/w==;
Received: from [177.238.16.239] (port=51466 helo=[192.168.0.21])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1ugTkl-00000004JMC-0oiF;
	Mon, 28 Jul 2025 14:43:19 -0500
Message-ID: <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
Date: Mon, 28 Jul 2025 13:43:10 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible array
 purex_item.iocb
To: Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>, Kees Cook <kees@kernel.org>,
 Bryan Gurney <bgurney@redhat.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20250728185725.2501761-1-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.16.239
X-Source-L: No
X-Exim-ID: 1ugTkl-00000004JMC-0oiF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.16.239]:51466
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAQAQ6YRMi8T6HHQD5vL0XMShhcmdoSkeds1gvs3+ZMLXCEtSldsJ2tKN/TsLHcaTmy7gQv0JR/FtKqbRJo7KSGWmW0aUbvsAY4v/rRjaLJiAKUKdarR
 E19CZbRuDWUhrTcAsZPKRxVxY3iXnx2kkbMD4aPyM1aSZQzQOK9HNYi+/fsgGmif6P49D4yYTMrntH0jr8HTq/DB/NkKy4oP7KxMq4MkNPmNoUlPsooqV1Sg



On 28/07/25 12:57, Chris Leech wrote:
> purex_item.iocb is defined as a 64-element u8 array, but 64 is the
> minimum size and it can be allocated larger.
> This makes it a standard empty flex array.
> 
> This was motivated by field-spanning write warnings during FPIN testing.
> https://lore.kernel.org/linux-nvme/20250709211919.49100-1-bgurney@redhat.com/
> 
>    >  kernel: memcpy: detected field-spanning write (size 60) of single field
>    >  "((uint8_t *)fpin_pkt + buffer_copy_offset)"
>    >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)
> 
> I removed the outer wrapper from the iocb flex array, so that it can be
> linked to purex_item.size with __counted_by.
> 
> The non-flex-array portion of purex_item is now defined within the
> struct_group_tagged macro to create a type definition for just the
> header. This was then used for the scsi_qla_host.default_item
> definition to deal with -Wflex-array-member-not-at-end warnings.
> 
> These changes remove the default minimum 64-byte allocation, requiring
> further changes.
> 
>    In struct scsi_qla_host the embedded default_item is now followed by
>    __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE] to reserve space that
>    will be used as default_item.iocb
> 
>    qla24xx_alloc_purex_item is adjusted to no longer expect the default
>    minimum size to be part of sizeof(struct purex_item), the entire
>    flexible array size is added to the structure size for allocation.
> 
> This also slightly changes the layout of the purex_item struct, as
> 2-bytes of padding are added to purex_item_hdr and therefor between size
> and iocb. The resulting size is the same, but iocb is shifted 2-bytes
> (the old purex_item was padded at the end, after the 64-byte defined
> array size). I don't think this is a problem.
> 
> Tested-by: Bryan Gurney <bgurney@redhat.com>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  | 23 ++++++++++++-----------
>   drivers/scsi/qla2xxx/qla_isr.c  | 19 +++++++++----------
>   drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
>   drivers/scsi/qla2xxx/qla_os.c   |  9 +++++----
>   4 files changed, 27 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index cb95b7b12051d..0e7d201b1feb0 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4883,16 +4883,16 @@ struct active_regions {
>    * is variable) starting at "iocb".
>    */
>   struct purex_item {
> -	void *purls_context;
> -	struct list_head list;
> -	struct scsi_qla_host *vha;
> -	void (*process_item)(struct scsi_qla_host *vha,
> -			     struct purex_item *pkt);
> -	atomic_t in_use;
> -	uint16_t size;
> -	struct {
> -		uint8_t iocb[64];
> -	} iocb;
> +	struct_group_tagged(purex_item_hdr, __hdr,
> +		void *purls_context;
> +		struct list_head list;
> +		struct scsi_qla_host *vha;
> +		void (*process_item)(struct scsi_qla_host *vha,
> +				     struct purex_item *pkt);
> +		atomic_t in_use;
> +		uint16_t size;
> +	);
> +	uint8_t iocb[] __counted_by(size);
>   };
>   
>   #include "qla_edif.h"
> @@ -5101,7 +5101,8 @@ typedef struct scsi_qla_host {
>   		struct list_head head;
>   		spinlock_t lock;
>   	} purex_list;
> -	struct purex_item default_item;
> +	struct purex_item_hdr default_item;
> +	uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
>   
>   	struct name_list_extended gnl;
>   	/* Count of active session/fcport */
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index fe98c76e9be32..a00c06a9898ec 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1077,17 +1077,17 @@ static struct purex_item *
>   qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>   {
>   	struct purex_item *item = NULL;
> -	uint8_t item_hdr_size = sizeof(*item);
>   
>   	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
> -		item = kzalloc(item_hdr_size +
> -		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
> +		item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);

With the inclusion of `counted_by`, I think `item->size` should be updated
here:
		item->size = size;

>   	} else {
>   		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
> -			item = &vha->default_item;
> +			item = (struct purex_item *)&vha->default_item;
>   			goto initialize_purex_header;
>   		} else {
> -			item = kzalloc(item_hdr_size, GFP_ATOMIC);
> +			item = kzalloc(
> +				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
> +				GFP_ATOMIC);

...and here:
			item->size = QLA_DEFAULT_PAYLOAD_SIZE;

Then remove `item->size = size;` just before `return item;`

Thanks
-Gustavo

>   		}
>   	}
>   	if (!item) {
> @@ -1127,17 +1127,16 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
>    * @vha: SCSI driver HA context
>    * @pkt: ELS packet
>    */
> -static struct purex_item
> -*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
> +static struct purex_item *
> +qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>   {
>   	struct purex_item *item;
>   
> -	item = qla24xx_alloc_purex_item(vha,
> -					QLA_DEFAULT_PAYLOAD_SIZE);
> +	item = qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE);
>   	if (!item)
>   		return item;
>   
> -	memcpy(&item->iocb, pkt, sizeof(item->iocb));
> +	memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
>   	return item;
>   }
>   
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 8ee2e337c9e1b..92488890bc04e 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
>   
>   	ql_dbg(ql_dbg_unsol, vha, 0x2121,
>   	       "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
> -	       item->iocb.iocb[3], item->size, uctx->exchange_address,
> +	       item->iocb[3], item->size, uctx->exchange_address,
>   	       fcport->d_id.b24);
>   	/* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
>   	 * ----- -----------------------------------------------
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d4b484c0fd9d7..ef8a4fce0e03c 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3971,7 +3971,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   static inline void
>   qla24xx_free_purex_list(struct purex_list *list)
>   {
> -	struct purex_item *item, *next;
> +	struct purex_item_hdr *item, *next;
>   	ulong flags;
>   
>   	spin_lock_irqsave(&list->lock, flags);
> @@ -6459,9 +6459,10 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
>   void
>   qla24xx_free_purex_item(struct purex_item *item)
>   {
> -	if (item == &item->vha->default_item)
> -		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
> -	else
> +	if (item == (struct purex_item *)&item->vha->default_item) {
> +		memset(&item->vha->default_item, 0, sizeof(struct purex_item_hdr));
> +		memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
> +	} else
>   		kfree(item);
>   }
>   

