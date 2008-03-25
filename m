From: Marc Bejarano <beej@alum.mit.edu>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Tue, 25 Mar 2008 19:43:02 -0400
Message-ID: <200803252343.m2PNh8kl020506@colby.verdasys.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colby.verdasys.com ([69.20.67.85]:35719 "EHLO
	colby.verdasys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbYCYXnQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 19:43:16 -0400
In-Reply-To: <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Grant Grundler <grundler@google.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

At 18:14 3/11/2008, Marc Bejarano wrote:
 >At 11:36 3/10/2008, James Bottomley wrote:
 >>On Fri, 2008-03-07 at 17:40 -0500, Marc Bejarano wrote:
 >>> This is hard to explain.  It looks like page 309713975 got written
 >>> out to the proper spot, but then the first 10752 bytes got written
 >>> out again to the wrong spot?!?
 >>
 >>this pattern of corruption
 >>is almost completely definitive of a disk problem with head positioning.

<snip>

 >>I'm afraid the only way to confirm this theory definitively will be with
 >>the destructive disktest from autotest (it was actually constructed to
 >>check for drive head positioning errors)
 >
 >thanks to you (and grant) for the pointer!  will try that next.

unfortunately,  we have been unable to reproduce the corruption using 
disktest :(  running for days ends up with no corruption.  my 
colleague had already written a similar tool and wasn't able to 
reproduce the problem with it, either.  i don't think this rules out 
a head positioning problem, though.

we can easily reproduce the issue using the server's intended 
workload with the intended configuration, but that isn't something we 
can give to seagate to reproduce in-house.

having never played with blocktrace, i have no idea what it's 
capabilities are.  can it be used to record not just the IOs, but 
also their timings?  any other ideas?  i'm at a loss for how to turn 
my reproducible test case into something i can send to seagate for 
investigation.

thanks,
marc

