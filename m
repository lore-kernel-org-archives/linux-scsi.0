From: Austin Gonyou <austin@digitalroadkill.net>
Subject: Re: [Possibly OT] Re: /proc/scsi/map
Date: 18 Jun 2002 11:24:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1024417474.7690.46.camel@UberGeek>
References: <OF23543BD5.0C1295FA-ON87256BDC.00569E7A@boulder.ibm.com>
	 <1024416395.7685.36.camel@UberGeek>  <20020618120810.C7800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020618120810.C7800@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Kurt Garloff <kurt@garloff.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, 2002-06-18 at 11:08, Doug Ledford wrote:
> On Tue, Jun 18, 2002 at 11:06:35AM -0500, Austin Gonyou wrote:
> > 
> > 
> > On Tue, 2002-06-18 at 10:49, Bryan Henderson wrote:
> > ....
> > > But we do have look out for other cases.  Like non-storage devices.
> > > 
> > 
> > I'm not sure what you mean here?
> 
> He's talking about the fact that you can put a volume label on a disk 
> drive, but it's hard to do the same to a tape drive or maybe a SCSI 
> DVD-RAM drive or anything else where you can't write to a permanent part 
> of the device instead of a removeable part of the device.

Ahh...off-line storage devices. Kind of hard to write a label to a
non-storage device. (/dev/null is a non-storage device right? :) )


-- 
Austin Gonyou <austin@digitalroadkill.net>
