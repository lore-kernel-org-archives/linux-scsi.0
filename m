From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Possibly OT] Re: /proc/scsi/map
Date: Tue, 18 Jun 2002 12:08:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020618120810.C7800@redhat.com>
References: <OF23543BD5.0C1295FA-ON87256BDC.00569E7A@boulder.ibm.com> <1024416395.7685.36.camel@UberGeek>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1024416395.7685.36.camel@UberGeek>; from austin@digitalroadkill.net on Tue, Jun 18, 2002 at 11:06:35AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Austin Gonyou <austin@digitalroadkill.net>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Kurt Garloff <kurt@garloff.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, Jun 18, 2002 at 11:06:35AM -0500, Austin Gonyou wrote:
> 
> 
> On Tue, 2002-06-18 at 10:49, Bryan Henderson wrote:
> ....
> > But we do have look out for other cases.  Like non-storage devices.
> > 
> 
> I'm not sure what you mean here?

He's talking about the fact that you can put a volume label on a disk 
drive, but it's hard to do the same to a tape drive or maybe a SCSI 
DVD-RAM drive or anything else where you can't write to a permanent part 
of the device instead of a removeable part of the device.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
