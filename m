From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [rfc][patch 1/3] block: non-atomic queue_flags prep
Date: Wed, 19 Dec 2007 19:13:37 +0100
Message-ID: <20071219181336.GC10470@kernel.dk>
References: <20071215054315.GA30335@wotan.suse.de> <20071218074439.GB31964@kernel.dk> <20071218081350.GA32114@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:7528 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXLSSNl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Dec 2007 13:13:41 -0500
Content-Disposition: inline
In-Reply-To: <20071218081350.GA32114@wotan.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, Dec 18 2007, Nick Piggin wrote:
> On Tue, Dec 18, 2007 at 08:44:40AM +0100, Jens Axboe wrote:
> > On Sat, Dec 15 2007, Nick Piggin wrote:
> > > Hi,
> > > 
> > > This is just an idea I had, which might make request processing a little
> > > bit cheaper depending on queue behaviour. For example if it is getting plugged
> > > unplugged frequently (as I think is the case for some database workloads),
> > > then we might save one or two atomic operations per request.
> > > 
> > > Anyway, I'm not completely sure if I have ensured all queue_flags users are
> > > safe (I think md may need a bit of help). But overall it seems quite doable.
> > 
> > Looks ok to me, I'll throw it into the testing mix. Thanks Nick!
> 
> OK... actually if you are expecting it to be widely tested, can you change
> the BUG_ONs in queue_flag_set / queue_flag_clear into WARN_ON?
> 
> That way it's less likely to take down people's systems...

Agree, will do so.

-- 
Jens Axboe

