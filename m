From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 13:33:02 -0400
Message-ID: <20050710173302.GE14956@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org> <20050710033431.GB13883@havoc.gtf.org> <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave> <20050710155839.GC14956@phunnypharm.org> <1121015154.5078.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:17380 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261982AbVGJRdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:33:04 -0400
Content-Disposition: inline
In-Reply-To: <1121015154.5078.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

> > Looking the pre TYPE_RBC code, I can see that the modepage change wasn't
> > there, so sure enough we were using 8. Could this cause an
> > ILLEGAL_REQUEST, and thus disable use_10_for_{rw,ms}?
> 
> Yes, that was the core of the bug Al was fixing.  sd has been requesting
> caching data for a while now.  However, for RBC devices it was probing
> the wrong mode page and failing.  After the changes we actually get the
> correct caching data.

Well, what I was asking was that since we were working with modepage=8,
could the switch to modepage=6 with the new code be causing our problems?

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
