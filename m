From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dc395x [1/6] - make functions static
Date: Thu, 21 Aug 2003 11:46:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821114632.A9401@infradead.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:27410 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262624AbTHUKqf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:46:35 -0400
Content-Disposition: inline
In-Reply-To: <20030821101434.GB7570@twibble.org>; from lenehan@twibble.org on Thu, Aug 21, 2003 at 08:14:34PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

On Thu, Aug 21, 2003 at 08:14:34PM +1000, Jamie Lenehan wrote:
> I forgot to make some of the new functions added during the list
> cleanups static. This patch just declares those new functions static.
> 
> diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> --- a/drivers/scsi/dc395x.c	2003-08-19 23:24:41.797147152 +1000
> +++ b/drivers/scsi/dc395x.c	2003-08-19 23:24:49.822927048 +1000
> @@ -822,6 +822,7 @@
>   *
>   * @head: The pointer to the head of the list to count the items in.
>   **/
> +static
>  unsigned int list_size(struct list_head *head)

the static belongs on the same line as the prototype.

