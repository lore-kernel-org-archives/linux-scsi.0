From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Thu, 29 Jan 2004 09:49:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040129094910.F11527@vienna.EGENERA.COM>
References: <3356669BBE90C448AD4645C843E2BF2802C013B0@xbl.ma.emulex.com> <1075328212.2534.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:12698 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S266122AbUA2Ovh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 09:51:37 -0500
Content-Disposition: inline
In-Reply-To: <1075328212.2534.14.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Jan 28, 2004 at 05:16:51PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Smart, James" <James.Smart@Emulex.com>, 'Patrick Mansfield' <patmans@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

Rumor has it that on Wed, Jan 28, 2004 at 05:16:51PM -0500 James Bottomley said:
> On Wed, 2004-01-28 at 16:02, Smart, James wrote:
> > I'd add one additional issue :
> > 
> > 3) SCSI Reservations
> > 
> > I guess this could be considered a part of (2), but given that reservations
> > bring in a host of additional problems, and potentially brings up multi-host
> > configs/clusters as well...
> 
> The current crop of cluster implementations that use reservations manage
> quite well in user space alone.  Certainly, though, the presence of
> reservations can interfere with failover code and may be considered a
> problem that needs to be solved in multi-path...it all depends on how
> the multi-path devices react to path switching in the face of
> reservations.
> 

It needs to be known to the pathing layer if you've got load balancing. 
It has to know which path has the reservation and only use that one.
 
> I'm open to suggestions on this,  but I think it should be done
> separately as part of a device ownership API.
> 
> James
> 

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
