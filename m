From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Wed, 06 Aug 2014 15:29:47 +0200
Message-ID: <53E22DCB.2070407@interlog.com>
References: <bug-80711-11613@https.bugzilla.kernel.org/> <bug-80711-11613-Y5RedyvzAB@https.bugzilla.kernel.org/>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55805 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaHFN3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2014 09:29:51 -0400
In-Reply-To: <bug-80711-11613-Y5RedyvzAB@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 14-07-29 05:57 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=80711
>
> Alan <alan@lxorguk.ukuu.org.uk> changed:
>
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                   CC|                            |alan@lxorguk.ukuu.org.uk
>              Summary|SG_FLAG_LUN_INHIBIT is no   |[PATCH]SG_FLAG_LUN_INHIBIT
>                     |longer implemented and      |is no longer implemented
>                     |there's not way to prevent  |and there's not way to
>                     |the kernel from using the   |prevent the kernel from
>                     |2nd cdb byte for the LUN    |using the 2nd cdb byte for
>                     |                            |the LUN
>
> --- Comment #3 from Alan <alan@lxorguk.ukuu.org.uk> ---
> Patches need to go to the mailing list and/or maintainers. See
> Documentation/SubmittingPatches.

In my original rework of the sg driver (1998) it did what
was being requested in this patch. Then around 10 years ago
changes were added to the SCSI subsystem to strip this
capability from the sg driver. Since then about 5 attempts (my
guess) have been made to re-instate this capability, this
being the most recent.

The use case is almost always the same: specialized USB
storage devices. USB is not going away. Does anyone see
a change in "company" policy in this regard?


If not and since I'm told black lists and the like won't
work, my advice for the record is to use FreeBSD or Windows
for tools that need this capability.

Doug Gilbert


