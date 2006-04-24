From: Michael Reed <mdr@sgi.com>
Subject: Re: Fw: [BUG] 2.6.17-rc1: SCSI kobject_add problems
Date: Mon, 24 Apr 2006 10:07:18 -0500
Message-ID: <444CE9A6.6030304@sgi.com>
References: <20060407171433.06e454bd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:10951 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750897AbWDXPHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 11:07:40 -0400
In-Reply-To: <20060407171433.06e454bd.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org, rct@gherkin.frus.com

See my post on 4/21:

	"2.6.17-rc2: kobject_add failed"

	http://marc.theaimsgroup.com/?l=linux-scsi&m=114563629810793&w=2

Perhaps this is related?

http://marc.theaimsgroup.com/?t=114443491400001&r=1&w=2

Mike


Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Fri, 7 Apr 2006 13:31:05 -0500 (CDT)
> From: rct@gherkin.frus.com (Bob Tracy)
> To: linux-kernel@vger.kernel.org
> Subject: [BUG] 2.6.17-rc1: SCSI kobject_add problems
> 
> 
> System is a DEC Alpha 433au with two SCSI disks.  SCSI controller is a
> QLA1040 supported by the qla1280 driver.  Runs 2.6.16 fine.  Tried
> booting 2.6.17-rc1 and got
> 
> kobject_add failed for 0:0: with -EEXIST, don't try to register things with the same name in the same directory
> 
> and a fairly long trace output when the system attempted to add sdb.
> Not surprisingly, sdb was inaccessible.
> 
> Normally (for 2.6.16 anyway), the following relationship exists:
> 
> sd 0:0:0:0	sda
> sd 0:0:1:0	sdb
> 
> More information *might* be available if needed, but will have to be
> transcribed by hand.  My /usr partition is on sdb, so I don't get very
> far with 2.6.17-rc1 on Alpha :-).  The problem is probably specific to
> the qla1280 or the Alpha, as I have a x86 Adaptec SCSI-based system
> with multiple spindles that works fine with 2.6.17-rc1.
> 
