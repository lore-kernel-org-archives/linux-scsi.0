From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 15:38:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031203832.GG30047@redhat.com>
References: <20021031200758.GB30047@redhat.com> <Pine.BSF.4.21.0210311225260.23076-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0210311225260.23076-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

On Thu, Oct 31, 2002 at 12:26:15PM -0800, Matthew Jacob wrote:
> > 
> > We currently only do report luns on SCSI-3 devices.  I didn't think this 
> > was a supported command on SCSI-2, but I hadn't checked the spec 
> > recently...hmmm...nope, not supported in SCSI-2, so using report luns on 
> > SCSI-2 devices is just as much a hack as going above lun 7 on SCSI-2 
> > devices without specific knowledge of transfer interconnect.
> 
> It's transitional in that a number of devices report as SCSI-2 but do
> things like REPORT LUNs. It's changing very fast though.

And we recently added INQUIRY with the EVPD bit set and an EVPD page 0.  
>From the reports I've seen, I'm pretty sure it's causing a more than
trivial number of devices to lock up on boot.  I suspect blindly pulling a
REPORT_LUNS on SCSI-2 devices would likely cause similar problems.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
