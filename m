From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] update scsi_eh_get_sense commentary
Date: Wed, 25 Aug 2004 09:52:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412C99A8.3060508@adaptec.com>
References: <20040824213827.GA27904@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64413 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267473AbUHYNwn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 09:52:43 -0400
In-Reply-To: <20040824213827.GA27904@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

Very good!

Christoph Hellwig wrote:
> 
> --- 1.79/drivers/scsi/scsi_error.c      2004-06-19 16:47:16 +02:00
> +++ edited/drivers/scsi/scsi_error.c    2004-08-24 13:38:13 +02:00
> @@ -643,15 +643,13 @@
>   * Notes:
>   *    This has the unfortunate side effect that if a shost adapter does
>   *    not automatically request sense information, that we end up shutting
> - *    it down before we request it.  All shosts should be doing this
> - *    anyways, so for now all I have to say is tough noogies if you end up
> - *    in here.  On second thought, this is probably a good idea.  We
> - *    *really* want to give authors an incentive to automatically request
> - *    this.
> + *    it down before we request it.
>   *
> - *    In 2.5 this capability will be going away.
> + *    All drivers should request sense information internally these days,
> + *    so for now all I have to say is tough noogies if you end up in here.
>   *
> - *    Really?  --hch
> + *    XXX: Long term this code should go away, but that needs an audit of
> + *         all LLDDs first.
>   **/
>  static int scsi_eh_get_sense(struct list_head *work_q,
>                              struct list_head *done_q)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

