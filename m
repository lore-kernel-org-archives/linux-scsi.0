From: Ishai Rabinovitz <ishai@mellanox.co.il>
Subject: Re: Receiving a SCSI response after abort task was sent
Date: Sun, 2 Jul 2006 18:14:08 +0300
Message-ID: <20060702151408.GA11036@mellanox.co.il>
References: <44A7A547.6080709@voltaire.com> <20060702132231.GA10030@mellanox.co.il> <44A7CE8E.1010106@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxl145v68.mxlogic.net ([208.65.145.68]:6822 "EHLO
	p02c11o145.mxlogic.net") by vger.kernel.org with ESMTP
	id S932312AbWGBP13 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 11:27:29 -0400
Content-Disposition: inline
In-Reply-To: <44A7CE8E.1010106@voltaire.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@voltaire.com>
Cc: linux-scsi@vger.kernel.org, vu@mellanox.com

On Sun, Jul 02, 2006 at 04:47:58PM +0300, Erez Zilber wrote:
> Ishai Rabinovitz wrote:
> >On Sun, Jul 02, 2006 at 01:51:51PM +0300, Erez Zilber wrote:
> >  
> Did you find any ref for this in SAM3? The only thing that I was able to 
> find there is that a target that receives an "abort task" has to send a 
> task management response even if it has already sent a SCSI response for 
> that task.
> 
> Thanks
> Erez

I'm using this feature (After the response to the ABORT I'm checking if I got
a response to the original request meanwhile).
In any case I think it is more efficient to handle the response and not the
abort.
It is safe for read requests. and I think it is safe also for write
requests since the target must have handled the request before handling the 
abort (Otherwise there would have been no response to the request).

Does anyone see a problem with that (Maybe with Multipath)?
-- 
Ishai Rabinovitz
