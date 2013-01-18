From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
Date: Fri, 18 Jan 2013 10:26:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301181024340.1988-100000@iolanthe.rowland.org>
References: <20130118082720.GA12599@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20130118082720.GA12599@aaronlu.sh.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 18 Jan 2013, Aaron Lu wrote:

> > Either you have to make sure the q->nr_pending is always correct, even 
> > when runtime PM isn't being used, or else the caller has to make sure 
> > that no I/O takes place before blk_pm_runtime_init is called.
> 
> I think we can say:
> blk_pm_runtime_init can't be called after any requests have been
> submitted but not finished.
> Sounds more accurate?

Okay.  I think you can add (in parentheses) that in most cases drivers
should call the routine before any I/O has taken place.

Alan Stern

