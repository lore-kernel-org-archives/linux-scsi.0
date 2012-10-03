From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 48241] New: oops when setting up LVM
Date: Wed, 03 Oct 2012 16:23:06 +0100
Message-ID: <1349277786.2404.24.camel@dabdike.int.hansenpartnership.com>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
Sender: linux-kernel-owner@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-10-03 at 15:04 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=48241
> 
>            Summary: oops when setting up LVM
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 3.6.0-next-20121003
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: daniel.santos@pobox.com
>         Regression: No
> 
> 
> Created an attachment (id=81921)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=81921)
> image of oops

The image says the RIP is at kthread_data + 0xb

That implies something went wrong within the workqueue or kthread
systems, I've cc'd linux-kernel, but it's a bit of a vague thing to go
on and could conceivably be a hardware issue (or some weird thread
interaction in linux-next).

The first question would be "does it happen in vanilla 3.6"?

James
