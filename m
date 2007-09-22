From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v2] libata: translate INQUIRY VPD page 89h (ATA info)
Date: Fri, 21 Sep 2007 21:05:40 -0400
Message-ID: <46F46A64.40707@garzik.org>
References: <20070921094825.GA15940@havoc.gtf.org> <20070922005444.GA29744@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070922005444.GA29744@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> +	memcpy(&pbuf[8], "ATA     ", 8);
> +	ata_id_string(args->id, &pbuf[16], ATA_ID_PROD, 16);
> +	ata_id_string(args->id, &pbuf[32], ATA_ID_FW_REV, 4);


And I just checked in a fix that changes the above to reflect the SCSI 
simulator's vendor/product/version (linux/libata/DRV_VERSION), rather 
than the ATA device's, as the spec wants.

	Jeff


