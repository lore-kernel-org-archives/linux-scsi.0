From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/14] lib: Add T10 Protection Information functions
Date: Wed, 11 Jun 2014 09:56:30 -0700
Message-ID: <20140611165630.GH9511@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-14-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaFKQ4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:56:33 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-14-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>  static struct blk_integrity dif_type1_integrity_crc = {

>
>  	.name			= "T10-DIF-TYPE1-CRC",
> -	.generate_fn		= sd_dif_type1_generate_crc,
> -	.verify_fn		= sd_dif_type1_verify_crc,
> -	.tuple_size		= sizeof(struct sd_dif_tuple),
> +	.generate_fn		= t10_pi_type1_generate_crc,
> +	.verify_fn		= t10_pi_type1_verify_crc,
> +	.tuple_size		= sizeof(struct t10_pi_tuple),
>  	.tag_size		= 0,
>  };

Shouldn't the whole profile defintions move to the generic
code as well?  Maybe the code also should live in block/ and not lib/.

