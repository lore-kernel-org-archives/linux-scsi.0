From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls Re:  [PATCH] Block layer: separate out queue-oriented ioctls
Date: Mon, 2 Apr 2007 16:23:20 +0200
Message-ID: <20070402142318.GA14256@kernel.dk>
References: <200704020828.l328SICc009264@burner.fokus.fraunhofer.de> <Pine.LNX.4.44L0.0704020951180.1743-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:2782 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965491AbXDBO2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2007 10:28:53 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0704020951180.1743-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <schilling@fokus.fraunhofer.de>, dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Mon, Apr 02 2007, Alan Stern wrote:
> On Mon, 2 Apr 2007, Joerg Schilling wrote:
> 
> > Hi,
> > 
> > this is a repost as I like to know the current state of the problem...
> > 
> > The USB DMA size problem is known to exist on Linux since February 2004.
> > I am still in hope that there will be a fix soon.
> 
> Me too.  I submitted the most recent version of the patch (labelled as857) 
> over a month ago and have received essentially no feedback on it.
> 
> Douglas, James...  What's the story?

FWIW, it had my ack, I think we were just waiting for Doug to ack the sg
bits.

-- 
Jens Axboe

