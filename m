From: Tejun Heo <tj@kernel.org>
Subject: Re: Disk spin-up optimization during system resume
Date: Sat, 18 Jan 2014 08:59:31 -0500
Message-ID: <20140118135931.GB3640@htj.dyndns.org>
References: <20140117202433.GB23024@htj.dyndns.org>
 <Pine.LNX.4.44L0.1401172034180.945-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f47.google.com ([209.85.128.47]:43060 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaARN7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 08:59:34 -0500
Received: by mail-qe0-f47.google.com with SMTP id 5so5068335qeb.34
        for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2014 05:59:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401172034180.945-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hello,

On Fri, Jan 17, 2014 at 08:41:00PM -0500, Alan Stern wrote:
> The intention is that this will help on systems with more than one
> disk drive.  The one containing the core OS files and the journal will
> certainly spin up right away, but the others may not.
> 
> To tell the truth, I'm not sure how useful this feature would be to
> most people.  But there probably are a few, like Phillip, who will be
> glad to have it.  That seems like sufficient justification for adding 
> it.

Unfortunately, that doesn't seem like a sufficient justification for
me.  If it's something completely trivial, maybe, but if it involves
any level of complexity, it better be actually useful.

Thanks.

-- 
tejun
