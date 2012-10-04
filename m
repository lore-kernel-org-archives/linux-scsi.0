From: Daniel Santos <danielfsantos@att.net>
Subject: Re: [Bug 48241] New: oops when setting up LVM (3.6.0-next-20121003)
Date: Thu, 04 Oct 2012 02:34:54 -0500
Message-ID: <506D3C1E.4050704@att.net>
References: <bug-48241-11613@https.bugzilla.kernel.org/> <1349277786.2404.24.camel@dabdike.int.hansenpartnership.com>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349277786.2404.24.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2012 10:23 AM, James Bottomley wrote:
> On Wed, 2012-10-03 at 15:04 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=48241
>>
>>            Summary: oops when setting up LVM
>>            Product: IO/Storage
>>            Version: 2.5
>>     Kernel Version: 3.6.0-next-20121003
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: SCSI
>>         AssignedTo: linux-scsi@vger.kernel.org
>>         ReportedBy: daniel.santos@pobox.com
>>         Regression: No
>>
>>
>> Created an attachment (id=81921)
>>  --> (https://bugzilla.kernel.org/attachment.cgi?id=81921)
>> image of oops
>
> The image says the RIP is at kthread_data + 0xb
>
> That implies something went wrong within the workqueue or kthread
> systems, I've cc'd linux-kernel, but it's a bit of a vague thing to go
> on and could conceivably be a hardware issue (or some weird thread
> interaction in linux-next).
>
> The first question would be "does it happen in vanilla 3.6"?
>
> James
So just to CC LKML, works in vanilla 3.6.0, happens in both -next & -mm,
tried compiling with both gcc 4.6.3 & 4.7.1.

Daniel
