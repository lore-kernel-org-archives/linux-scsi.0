From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 03/24] aha152x: Debug output update and whitespace
 cleanup
Date: Fri, 3 Oct 2014 00:01:09 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBD0C@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:28934 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJCADH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 20:03:07 -0400
In-Reply-To: <1412144580-72880-4-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index e77b72f..e1aba73 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
...
> @@ -345,10 +311,10 @@ CMD_INC_RESID(struct scsi_cmnd *cmd, int inc)
> 
>  enum {
>  	not_issued	= 0x0001,	/* command not yet issued */
> -	selecting	= 0x0002, 	/* target is beeing selected */
> +	selecting	= 0x0002,	/* target is beeing selected */

You might want to fix the spelling of "being" 
while modifying that line.


