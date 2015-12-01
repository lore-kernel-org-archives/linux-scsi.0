From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/3] arcmsr: modify codes for more readable
Date: Tue, 01 Dec 2015 14:40:41 +0100
Message-ID: <1448977241.3103.30.camel@suse.de>
References: <1448537636.10768.39.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbbLANkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 08:40:43 -0500
In-Reply-To: <1448537636.10768.39.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
Cc: hch@lst.de

On Thu, 2015-11-26 at 19:33 +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> modify codes for more readable
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 18:08:52.000000000
> +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-26 15:52:54.000000000
> +0800
> @@ -2814,53 +2814,32 @@ static bool arcmsr_hbaD_get_config(struc
> =C2=A0	acb->dma_coherent2 =3D dma_coherent2;
> =C2=A0	reg =3D (struct MessageUnit_D *)dma_coherent2;
> =C2=A0	acb->pmuD =3D reg;
> -	reg->chip_id =3D acb->mem_base0 + ARCMSR_ARC1214_CHIP_ID;
> -	reg->cpu_mem_config =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION;
> -	reg->i2o_host_interrupt_mask =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK;
> -	reg->sample_at_reset =3D acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RES=
ET;
> -	reg->reset_request =3D acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUES=
T;
> -	reg->host_int_status =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS;
> -	reg->pcief0_int_enable =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE;
> -	reg->inbound_msgaddr0 =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_INBOUND_MESSAGE0;
> -	reg->inbound_msgaddr1 =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_INBOUND_MESSAGE1;
> -	reg->outbound_msgaddr0 =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_MESSAGE0;
> -	reg->outbound_msgaddr1 =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_MESSAGE1;
> -	reg->inbound_doorbell =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_INBOUND_DOORBELL;
> -	reg->outbound_doorbell =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_DOORBELL;
> -	reg->outbound_doorbell_enable =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE;
> -	reg->inboundlist_base_low =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW;
> -	reg->inboundlist_base_high =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH;
> -	reg->inboundlist_write_pointer =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER;
> -	reg->outboundlist_base_low =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW;
> -	reg->outboundlist_base_high =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH;
> -	reg->outboundlist_copy_pointer =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER;
> -	reg->outboundlist_read_pointer =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER;
> -	reg->outboundlist_interrupt_cause =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE;
> -	reg->outboundlist_interrupt_enable =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE;
> -	reg->message_wbuffer =3D acb->mem_base0 +
> ARCMSR_ARC1214_MESSAGE_WBUFFER;
> -	reg->message_rbuffer =3D acb->mem_base0 +
> ARCMSR_ARC1214_MESSAGE_RBUFFER;
> -	reg->msgcode_rwbuffer =3D acb->mem_base0 +
> -		ARCMSR_ARC1214_MESSAGE_RWBUFFER;
> +	reg->chip_id =3D MEM_BASE0(ARCMSR_ARC1214_CHIP_ID);
> +	reg->cpu_mem_config =3D
> MEM_BASE0(ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
> +	reg->i2o_host_interrupt_mask =3D
> MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
> +	reg->sample_at_reset =3D MEM_BASE0(ARCMSR_ARC1214_SAMPLE_RESET);
> +	reg->reset_request =3D MEM_BASE0(ARCMSR_ARC1214_RESET_REQUEST);
> +	reg->host_int_status =3D
> MEM_BASE0(ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
> +	reg->pcief0_int_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
> +	reg->inbound_msgaddr0 =3D MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE0=
);
> +	reg->inbound_msgaddr1 =3D MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE1=
);
> +	reg->outbound_msgaddr0 =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
> +	reg->outbound_msgaddr1 =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
> +	reg->inbound_doorbell =3D MEM_BASE0(ARCMSR_ARC1214_INBOUND_DOORBELL=
);
> +	reg->outbound_doorbell =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL);
> +	reg->outbound_doorbell_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
> +	reg->inboundlist_base_low =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
> +	reg->inboundlist_base_high =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
> +	reg->inboundlist_write_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
> +	reg->outboundlist_base_low =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
> +	reg->outboundlist_base_high =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
> +	reg->outboundlist_copy_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
> +	reg->outboundlist_read_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
> +	reg->outboundlist_interrupt_cause =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
> +	reg->outboundlist_interrupt_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
> +	reg->message_wbuffer =3D MEM_BASE0(ARCMSR_ARC1214_MESSAGE_WBUFFER);
> +	reg->message_rbuffer =3D MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RBUFFER);
> +	reg->msgcode_rwbuffer =3D MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER=
);
> =C2=A0	iop_firm_model =3D (char __iomem *)(&reg->msgcode_rwbuffer[15]=
);
> =C2=A0	iop_firm_version =3D (char __iomem *)(&reg->msgcode_rwbuffer[1=
7]);
> =C2=A0	iop_device_map =3D (char __iomem *)(&reg->msgcode_rwbuffer[21]=
);
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
