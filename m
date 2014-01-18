From: Tejun Heo <tj@kernel.org>
Subject: Re: Disk spin-up optimization during system resume
Date: Sat, 18 Jan 2014 09:04:39 -0500
Message-ID: <20140118140439.GC3640@htj.dyndns.org>
References: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1401171513500.6173-100000@netrider.rowland.org>
 <20140117202433.GB23024@htj.dyndns.org>
 <52D998C2.7080302@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:37305 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaAROEn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 09:04:43 -0500
Received: by mail-qc0-f182.google.com with SMTP id c9so4647923qcz.27
        for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2014 06:04:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <52D998C2.7080302@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hello, Phillip.

On Fri, Jan 17, 2014 at 03:55:30PM -0500, Phillip Susi wrote:
> > What kind of use cases are we expecting for the lazy behavior?
> 
> Not all systems only have a single drive.  There may be a tendency for
> IO to the drive with the root fs on it after a resume, but multi drive
> systems often end up not touching the other disks so they go back into
> suspend shortly after resume, so the start/stop cycle was just
> needless wear and tear on the drive.

The problem is that the relevance of lazy behavior moves together with
the frequency of suspend/resume cycles.  So, it's something which
could be useful for machines with multiple rotating disks which
suspend and resume frequently?  It's a hard sell.  If it can be done
trivially, and I really mean "trivially", maybe.  If it involves
almost any level of complexity, I'd be highly reluctant to apply the
changes.  Its usefulness is not only marginal now, but it'll also
continue to fall rather rapidly.  Adding maintenance overhead for that
seems rather ill advised to me.

Thanks.

-- 
tejun
