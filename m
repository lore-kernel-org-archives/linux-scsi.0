From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: fix for cpqarray for 2.6.9-rc2
Date: Mon, 20 Sep 2004 15:45:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414F3377.9080106@pobox.com>
References: <20040920192420.GA5651@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:62953 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266073AbUITTqN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 15:46:13 -0400
In-Reply-To: <20040920192420.GA5651@beardog.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com
Cc: linux-kernel@vger.kernel.org, axboe@suse.de, linux-scsi@vger.kernel.org

mike.miller@hp.com wrote:
> diff -burNp lx269-rc2.orig/drivers/block/ida_cmd.h lx269-rc2/drivers/block/ida_cmd.h
> --- lx269-rc2.orig/drivers/block/ida_cmd.h	2004-08-14 00:36:44.000000000 -0500
> +++ lx269-rc2/drivers/block/ida_cmd.h	2004-09-20 14:15:39.782595128 -0500
> @@ -318,6 +318,8 @@ typedef struct {
>  	__u8	reserved[510];
>  } mp_delay_t;
>  
> +#define SENSE_SURF_STATUS       0x70


I guess the return codes for this op are along the lines of "calm", 
"bitchin", and "gnarly"?

	Jeff


