From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re: [PATCH 1/4] aic7xxx/aic79xx: call scsi_set_device()
Date: Sun, 29 May 2005 10:05:23 +0100
Message-ID: <20050529090523.GA20094@infradead.org>
References: <20050529074029.GA25962@havoc.gtf.org> <20050529082422.GA19685@infradead.org> <429982E8.4000503@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8345 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261288AbVE2JFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 05:05:25 -0400
Content-Disposition: inline
In-Reply-To: <429982E8.4000503@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Sun, May 29, 2005 at 04:52:56AM -0400, Jeff Garzik wrote:
> Christoph Hellwig wrote:
> >scsi_add_host connects the host to the device tree.  scsi_set_device
> >is obsolete and should go away ASAP.
> 
> Someone needs to tell authors of newer drivers not to use 
> scsi_set_device(), until it can be deleted...

I do so in every review :)

