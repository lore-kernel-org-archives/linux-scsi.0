From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 15688] New: mptsas & poor performance
Date: Mon, 5 Apr 2010 13:34:51 -0700
Message-ID: <20100405133451.fb20d65d.akpm@linux-foundation.org>
References: <bug-15688-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385Ab0DEUfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2010 16:35:32 -0400
In-Reply-To: <bug-15688-10286@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org, bexamous@gmail.com


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

scsi_drivers-other reports don't appear to be coming out on the
linux-scsi list.

On Sat, 3 Apr 2010 21:16:31 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=15688
> 
>            Summary: mptsas & poor performance
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 2.6.34-020634rc1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: bexamous@gmail.com
>         Regression: No
> 
> 
> The mptsas module from LSI's website, v4.18.00.00, performs much better than
> the mptsas module included in the kernel, v3.something.
> 
> I'm only comparing sequential writes (dd if=/dev/zero of=zeros bs=1M), but...
> 
> 6 drive MD RAID5 with fresh btrfs, writing 10GB of zeros with dd,
> kernel version:  <200MB/sec
> LSI's v4.18.00.00: 395MB/sec
> 
> Pretty big difference.  I've gone back and forth a few times,
> enabling/disabling write cache on the drives, enabling/disabling ioc,
> enabling/disabling filesystem barriers...  I can make small changes in
> performance but nothing compares to simply updating to v4.18.00.00.
> 


