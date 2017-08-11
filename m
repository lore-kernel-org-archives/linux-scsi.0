From: Cedric Sodhi <ManDay@openmail.cc>
Subject: Re: SCSI Oops: Unable to handle kernel NULL ptr dereference
Date: Fri, 11 Aug 2017 09:24:37 +0200
Message-ID: <20170811072437.GB2729@air>
References: <20170810170537.Horde.8CxBesYMH_QVGbAB7dui6vz@www.vfemail.net>
 <1502402499.4120.133.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from onethreetwo.vfemail.net ([199.16.11.132]:18141 "EHLO
        vfemail.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753173AbdHKNdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 09:33:54 -0400
Content-Disposition: inline
In-Reply-To: <1502402499.4120.133.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

Since the problem is fixed it didn't seem necessary to me to say that, but I later recalled what was different that could have caused the problem. I used a SATA to USB controller and while the disk was mounted and read from, I noticed that the SATA wasn't correctly plugged in (although it worked). When I attempted to adjust the plug proplery, the link broke (i.e. on the SATA side, not the USB side). I re-mounted afterwards and no persistent issue seemed to have been caused, but it might be the cause for this panic when I terminated wayland later (no idea what it has to do with wayland, but that's my only hypothesis).

Cedric

On Thu, Aug 10, 2017 at 06:01:39PM -0400, Ewan D. Milne wrote:
> [cc's snipped to linux-scsi ]
> 
> On Thu, 2017-08-10 at 17:05 +0000, manday@openmail.cc wrote:
> > Hello,
> > 
> > I'd like to report this rare panic I experienced today. I've been on  
> > 4.12.3 since it was released and got this panic totally unexpected,  
> > probably when terminating my WL compositor. I attach to this message a  
> > capture of the screen. The problem occurred never before and never  
> > after since, suggesting I will not be able to reproduce it easily.  
> > Perhaps it means something to someone.
> > 
> > Linux air 4.12.3 #4 SMP Fri Jul 28 12:07:06 CEST 2017 x86_64 Intel(R)  
> > Core(TM)i5-6267U CPU @ 2.90GHz GenuineIntel GNU/Linux
> > 
> > I don't know what additional information might be useful so if there  
> > is anything else I should provide please tell me.
> > 
> > Best regards,
> > Cedric
> 
> Your stack trace indicates some kind of corruption in a kmem cache
> used by the SCSI code, uncovered when the block queue was being freed.
> Can you describe what SCSI hardware is connected to your machine?
> A snippet of your boot messages showing the hardware probe would help.
> 
> -Ewan
> 
> 

-------------------------------------------------

ONLY AT VFEmail! - Use our Metadata Mitigator to keep your email out of the NSA's hands!
$24.95 ONETIME Lifetime accounts with Privacy Features!  
15GB disk! No bandwidth quotas!
Commercial and Bulk Mail Options!  
