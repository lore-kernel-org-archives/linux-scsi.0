From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v10 0/4] block layer runtime pm
Date: Thu, 21 Feb 2013 17:19:34 +0800
Message-ID: <20130221091934.GA8612@aaronlu.sh.intel.com>
References: <1361340717-8991-1-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1302201042400.1671-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1302201042400.1671-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 20, 2013 at 10:43:50AM -0500, Alan Stern wrote:
> On Wed, 20 Feb 2013, Aaron Lu wrote:
> 
> > In August 2010, Jens and Alan discussed about "Runtime PM and the block
> > layer". http://marc.info/?t=128259108400001&r=1&w=2
> > And then Alan has given a detailed implementation guide:
> > http://marc.info/?l=linux-scsi&m=133727953625963&w=2
> 
> > v10:
> > - Add link of Alan Stern's ideas on block layer runtime PM to patch 2
> >   and 3's changelog;
> > - Add back code to schdule device suspend if scsi driver return -EBUSY.
> 
> This all looks okay now.  You can add
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> to each of the patches.

Great, thanks a lot for your kind help.

Hi James,
Can I have your ack for patch 1 and 4?

And Jens,
Do you have any comments for this series?

Thanks,
Aaron

