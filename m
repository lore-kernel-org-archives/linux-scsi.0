From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Sat, 11 Jun 2005 19:18:20 +0100
Message-ID: <20050611181820.GA2771@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com> <20050611153745.GA31943@infradead.org> <20050611181516.GA8555@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3460 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261772AbVFKSSZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 14:18:25 -0400
Content-Disposition: inline
In-Reply-To: <20050611181516.GA8555@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Sat, Jun 11, 2005 at 11:15:16AM -0700, Patrick Mansfield wrote:
> What do you think of Mike C's patch, to add a transportt->scan function?
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=111671146532103&w=2
> 
> It needs a bit more code in the transport compared to the above. It also
> allows the transport to more efficiently scan (the transport can scan only
> devices it knows are attached, versus all id's up to max_id).

Looks good except that it's not updating the legacy procfs-based
scanning code.

