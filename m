From: Doug Ledford <dledford@redhat.com>
Subject: Re: /proc/scsi/map
Date: Tue, 18 Jun 2002 01:12:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020618011242.A7800@redhat.com>
References: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl> <20020617180818.C30391@redhat.com> <20020617230648.GA3448@gum01m.etpnet.phys.tue.nl> <20020617224046.A6590@redhat.com> <3D0EB7D0.FDB66BAA@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D0EB7D0.FDB66BAA@torque.net>; from dougg@torque.net on Tue, Jun 18, 2002 at 12:32:16AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Kurt Garloff <kurt@garloff.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>

On Tue, Jun 18, 2002 at 12:32:16AM -0400, Douglas Gilbert wrote:
> As for "scsihosts" its current syntax is:
>  scsihosts=aic7xxx:sym53c8xx::aic7xxx
> 
> This could be extended to
>   scsihosts=aic7xxx[pci=00:0c.0]:sym53c8xx::aic7xxx
> and if "pci=" was assumed to be the default then this
> would have the same effect as:
>   scsihosts=[00:0c.0]:sym53c8xx::aic7xxx
> assuming there was a aic7xxx controlled HBA at that PCI slot.
> 
> No consistent persistence here, just a little more precision.

I think that relies upon the SCSI controller using the newer PCI scanning 
methods (which, for example, my aic7xxx driver does not use).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
