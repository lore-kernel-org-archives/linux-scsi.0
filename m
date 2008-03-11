From: Marc Bejarano <beej@alum.mit.edu>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Tue, 11 Mar 2008 18:14:34 -0400
Message-ID: <200803112215.m2BMF1LU029876@colby.verdasys.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1205163386.2941.14.camel@localhost.localdomain>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Grant Grundler <grundler@google.com>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

At 11:36 3/10/2008, James Bottomley wrote:
 >On Fri, 2008-03-07 at 17:40 -0500, Marc Bejarano wrote:
 >> This is hard to explain.  It looks like page 309713975 got written
 >> out to the proper spot, but then the first 10752 bytes got written
 >> out again to the wrong spot?!?
 >
 >I'm afraid your not going to like this, but this pattern of corruption
 >is almost completely definitive of a disk problem with head positioning.

are you kidding?  i LOVE this :)  just to have a working theory is a 
huge relief.

 >It's still theoretically possible that something went wrong in the
 >actual HBA, but I'd place most of my money on a disk fault.

at this point, i'd do likewise.

 >Just as a matter of interest, what version of firmware do you have?

one of our early suspects was drive firmware.  we'd already been 
bitten once by a 7200.10 firmware "upgrade" messing us up.  this box 
was originally using a mix of 3.AAJ's and 3.AAK's, but since these 
were our first K's, we took them out of the picture.  since we have 
lots of J's in active use and had never seen any problems, i assumed 
they were fine and looked elsewhere.  going back over some other 
productions machines, it looks like all the important stuff is on 
pre-J's.  we don't seem to have J's in high-stress environments.

 >I'm afraid the only way to confirm this theory definitively will be with
 >the destructive disktest from autotest (it was actually constructed to
 >check for drive head positioning errors)

thanks to you (and grant) for the pointer!  will try that next.

cheers,
marc

