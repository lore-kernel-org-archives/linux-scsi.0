From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 17:36:41 -0800
Message-ID: <20140118013641.GA13645@linux.intel.com>
References: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1401171513500.6173-100000@netrider.rowland.org>
 <20140117202433.GB23024@htj.dyndns.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbaARBgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 20:36:38 -0500
Content-Disposition: inline
In-Reply-To: <20140117202433.GB23024@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dan Williams <dan.j.williams@intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 03:24:33PM -0500, Tejun Heo wrote:
> On Fri, Jan 17, 2014 at 03:15:54PM -0500, Alan Stern wrote:
> > You will have to argue this point with Phillip.
> > 
> > If necessary, we could add a sysfs attribute to force a spin-up during
> > system resume.  Or you could disable runtime PM for the disk, but that
> > has its own disadvantages.
> 
> Isn't immediate spin-up trivial to implement from anywhere?  I'm not
> sure whether we'll end up defaulting to the lazy behavior or not but
> if we do requiring userland to echo something to sysfs to configure
> immediate spin-up feels a bit silly when userland might as well just
> issue a dummy command to force spinup.
> 
> And, yes, I agree with Dan that avoiding spinup of harddrives on
> system resume seems a bit niche in its usefulness.  suspend/resume
> cycle at the very least generates logs which most likely will be
> committed to the drive sooner or later.
> 
> What kind of use cases are we expecting for the lazy behavior?

Phillip and Alan, some test data would also be helpful to back up your
point. 

> 
> Thanks.
> 
> -- 
> tejun
