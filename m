From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Tue, 15 May 2012 23:49:11 +0800
Message-ID: <1337096951.3515.11.camel@chief-river-32>
References: <Pine.LNX.4.44L0.1205151037500.1796-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205151037500.1796-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-05-15 at 10:39 -0400, Alan Stern wrote:
> On Tue, 15 May 2012, Lin Ming wrote:
> 
> > Add an idle timer that is set to some suitable timeout and would be
> > added when the queue first goes empty. If nothing has happened during
> > the timeout interval, then the queue is suspended.
> 
> You don't need to create an idle timer for runtime PM support; the 
> runtime PM framework already has such a timer.  Read 
> Documentation/power/runtime_pm.txt, especially the parts describing 
> pm_runtime_autosuspend() and related functions.

OK, will use pm_runtime_autosuspend.

> 
> Alan Stern
> 
