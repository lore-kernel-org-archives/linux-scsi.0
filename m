From: Doug Ledford <dledford@redhat.com>
Subject: Re: /proc/scsi/map
Date: Tue, 18 Jun 2002 12:09:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020618120939.D7800@redhat.com>
References: <OF9E7601D4.31CCE1B5-ON87256BDC.00556B8A@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF9E7601D4.31CCE1B5-ON87256BDC.00556B8A@boulder.ibm.com>; from hbryan@us.ibm.com on Tue, Jun 18, 2002 at 08:40:36AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Kurt Garloff <kurt@garloff.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, Jun 18, 2002 at 08:40:36AM -0700, Bryan Henderson wrote:
> 
> >There simply is *no* guarantee here of
> >any consistent naming, so don't bother trying to claim there is.
> 
> That's quite an overstatement.  With a minor and reasonable qualification,
> there is a guarantee.  That qualification is that you keep your controller
> numbers the same.  On the myriad systems that have only one controller,
> that is a very reasonable qualification indeed.

That's only reasonable for as long as you are going to exclude servers and 
SAN type storage environements.  I would argue that the people that are 
willing to live with your qualification, could likely live without this 
whole bit of software because they could just make their ZIP drive be the 
last one on the chain so no other devices get renumbered at boot up if 
their ZIP disk is off ;-)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
