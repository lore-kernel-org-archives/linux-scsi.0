From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/11][REPOST]  lpfc 8.1.1 : Add polled-mode support
Date: Wed, 30 Nov 2005 19:19:53 +0000
Message-ID: <20051130191953.GE19164@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C80@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61119 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751546AbVK3TTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:19:54 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C80@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 29, 2005 at 04:32:13PM -0500, James.Smart@Emulex.Com wrote:
> 
> Add polled-mode support to the driver:
> - Add functionality to run in polled mode only. Includes run time
>   attribute to enable mode.
> - Enable runtime writable hba settings for coallescing and delay parameters
> 
> Customers have requested a mode in the driver to run strictly polled.
> This is generally to support an environment where the server is extremely
> loaded and is looking to reclaim some cpu cycles from adapter interrupt
> handling.
> 
> This patch adds a new "poll" attribute, and the following behavior:

Care to put the nice description you wrote up into Documentation/scsi/lpfc.txt
so people are actually able to find it? No one is going to read through
changelog entries for module parameter discussion.

> +	if (!(val & DISABLE_FCP_RING_INT) &&
> +	    (old_val & DISABLE_FCP_RING_INT))
> +	{

still odd formatting :)

