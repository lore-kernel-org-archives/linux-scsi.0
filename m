From: "Abhijeet Arvind Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: [PATCH 1/6] fnic: add main file with module infrastructure,fnic structure, Makefile
Date: Mon, 27 Apr 2009 10:30:45 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D251FE7432@xmb-sjc-23e.amer.cisco.com>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com> <20090418013232.24787.33309.stgit@feynman.nuovasystems.com> <1240847076.3387.20.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:37909 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbZD0Rar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 13:30:47 -0400
Content-class: urn:content-classes:message
In-reply-to: <1240847076.3387.20.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, "Joe Eykholt (jeykholt)" <jeykholt@cisco.com>, Mike Christie <michaelc@cs.wisc.edu>

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Monday, April 27, 2009 8:45 AM
> To: Abhijeet Arvind Joglekar (abjoglek)
> Cc: linux-scsi@vger.kernel.org; Joe Eykholt (jeykholt)
> Subject: Re: [PATCH 1/6] fnic: add main file with module 
> infrastructure,fnic structure, Makefile
> 
> On Fri, 2009-04-17 at 18:32 -0700, Abhijeet Joglekar wrote:
> > fnic_main.c: include module load and unload, PCI device probe, 
> > scsi-ml, libFC and scsi-transport-fc registration and interfaces
> > 
> > fnic.h: has fnic definition and other related data types
> > 
> > Makefile:
> > 
> > Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
> > Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> I'm guessing this should be:
> 
> Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
> Reviewed-by: Joe Eykholt <jeykholt@cisco.com>
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> ?
> 
> James
> 

Joe is in the module-author and MAINTAINERS list, so his name should
have "Signed-off-by" tag.

As Mike said in his email, he contributed changes to driver and reviewed
the driver code. I put the "Signed-off-by" tag for Mike as a superset to
include his patch contributions + review. I am ok with the tag that you
and Mike think is appropriate.

thanks
-- abhijeet


