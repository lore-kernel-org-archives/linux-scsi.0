From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 41552] New: Performance of writing and reading
 from multiple drives decreases by 40% when going from Linux Kernel 2.6.36.4
 to 2.6.37 (and beyond)
Date: Mon, 22 Aug 2011 12:24:43 -0700
Message-ID: <20110822122443.c04839c8.akpm@linux-foundation.org>
References: <bug-41552-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1HVTZa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 15:25:30 -0400
In-Reply-To: <bug-41552-10286@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mpete_06@hotmail.com
Cc: bugme-daemon@bugzilla.kernel.org, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org, linux-scsi@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon, 22 Aug 2011 15:20:41 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=41552
> 
>            Summary: Performance of writing and reading from multiple
>                     drives decreases by 40% when going from Linux Kernel
>                     2.6.36.4 to 2.6.37 (and beyond)
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.37
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: mpete_06@hotmail.com
>         Regression: No
> 
> 
> We have an application that will write and read from every sector on a drive. 
> The application can perform these tasks on multiple drives at the same time. 
> It is designed to run on top of the Linux Kernel, which we periodically update
> so that we can get the latest device drivers.  When performing the last update
> from 2.6.33.2 to 2.6.37, we found that the performance of a set of drives
> decreased by some 40% (took 3 hours and 11 minutes to write and read from 5
> drives on 2.6.37 versus 2 hours and 12 minutes on 2.6.33.3).  I was able to
> determine that the issue was in the 2.6.37 Kernel as I was able to run it with
> the 2.6.36.4 kernel, and it had the better performance.   After seeing that I/O
> throttling was introduced in the 2.6.37 Kernel, I naturally suspected that. 
> However, by default, all the throttling was turned off (I attached the actual
> .config that was used to build the kernel).  I then tried to turn on the
> throttling and set it to a high number to see what would happen.  When I did
> that, I was able to reduce the time from 3 hours and 11 minutes to 2 hours and
> 50 minutes.  There seems to be something there that changed that is impacting
> performance on multiple drives.  When we do this same test with only one drive,
> the performance is identical between the systems.  This issue still occurs on
> Kernel 3.0.2.
> 

Are you able to determine whether this regression is due to slower
reading, to slower writing or to both?

Thanks.
