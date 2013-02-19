From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 3/4] block: implement runtime pm strategy
Date: Tue, 19 Feb 2013 11:34:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1302191134050.2215-100000@iolanthe.rowland.org>
References: <20130219022900.GA2285@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130219022900.GA2285@aaronlu.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 19 Feb 2013, Aaron Lu wrote:

> Hi Alan,
> 
> On Tue, Feb 05, 2013 at 04:03:15PM +0800, Aaron Lu wrote:
> > From: Lin Ming <ming.m.lin@intel.com>
> > 
> > When a request is added:
> >     If device is suspended or is suspending and the request is not a
> >     PM request, resume the device.
> > 
> > When the last request finishes:
> >     Call pm_runtime_mark_last_busy().
> > 
> > When pick a request:
> >     If device is resuming/suspending, then only PM request is allowed
> >     to go.
> 
> I think I should add the following words in patch 2 & 3's changelog:
> 
> The idea and API is designed by Alan Stern and described here:
> http://marc.info/?l=linux-scsi&m=133727953625963&w=2
> 
> to reflect your credit if you don't object.
> 
> Please let me know what do you think, or if there is a better way to
> reflect this, please feel free to let me know.

That's fine, go right ahead.

Alan Stern

