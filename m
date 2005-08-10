From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/2] sata: fix sata_sx4 dma_prep to not use sg->length
Date: Wed, 10 Aug 2005 17:24:06 -0400
Message-ID: <42FA7076.6060801@pobox.com>
References: <20050729050654.GA10413@havoc.gtf.org> <20050807054850.GA13335@htj.dyndns.org> <20050807055340.GB13335@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:34721 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030275AbVHJVYR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 17:24:17 -0400
In-Reply-To: <20050807055340.GB13335@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>

Tejun Heo wrote:
>  sata_sx4 directly references sg->length to calculate total_len in
> pdc20621_dma_prep().  This is incorrect as dma_map_sg() could have
> merged multiple sg's into one and, in such case, sg->length doesn't
> reflect true size of the entry.  This patch makes it use
> sg_dma_len(sg).
> 
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

applied to 2.6.13


