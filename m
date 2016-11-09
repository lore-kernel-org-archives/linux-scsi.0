From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 187381] New: 4.9.-rc4 produces hundreds of unusable scsi
 devices.
Date: Wed, 09 Nov 2016 12:49:21 -0800
Message-ID: <1478724561.18853.1.camel@HansenPartnership.com>
References: <bug-187381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35944 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753838AbcKIUtY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 15:49:24 -0500
In-Reply-To: <bug-187381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
Cc: samuel.silbory@hds.com

On Wed, 2016-11-09 at 20:20 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=187381
> 
>             Bug ID: 187381
>            Summary: 4.9.-rc4 produces hundreds of unusable scsi
> devices.
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 4.9-rc4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: samuel.silbory@hds.com
>         Regression: No
> 
> Created attachment 244091
>   --> 
> https://bugzilla.kernel.org/attachment.cgi?id=244091&action=edit
> Debian's kernel log file.  Note that this contains functional boots
> with older
> kernels as well earlier in the file.
> 
> With both my hand compiled 4.9-rc4 from kernel.org sources and
> Ubuntu's
> 4.9.0-040900rc4-generic the kernel creates hundred of useless
> /dev/sd??
> devices.  This system is fine with various 4.4, and 4.8 kernels.
> 
> The logs are spammed with messages like these
> 2016-11-09T12:17:00.021765-08:00 Node001 kernel: [75590.503155] Dev
> sdjm:
> unable to read RDB block 1
> 2016-11-09T12:17:00.021767-08:00 Node001 kernel: [75590.503188] 
>  sdjm: unable
> to read partition table
> 2016-11-09T12:17:00.021769-08:00 Node001 kernel: [75590.503191] sdjm:
> partition
> table beyond EOD, enabling native capacity
> 2016-11-09T12:17:00.021776-08:00 Node001 kernel: [75590.504463] sd 
> 1:3:126:0:

This was reported to the mailing list and should be fixed by this:

http://marc.info/?l=linux-scsi&m=147868920429684

We'll fast track this, but can you verify it fixes your issue.

Thanks,

James


