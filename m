From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Thu, 29 Jan 2004 10:31:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040129183114.GB896@beaverton.ibm.com>
References: <3356669BBE90C448AD4645C843E2BF2802C013BE@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:59873 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S266297AbUA2S0Q
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 13:26:16 -0500
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C013BE@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Philip R. Auld" <pauld@egenera.com>, 'Patrick Mansfield' <patmans@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

Smart, James [James.Smart@Emulex.com] wrote:
> 
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> > 
> > On Thu, 2004-01-29 at 09:49, Philip R. Auld wrote:
> > > It needs to be known to the pathing layer if you've got 
> > load balancing. 
> > > It has to know which path has the reservation and only use that one.
> > 
> > Well, yes, but your multiple active path implementation just collapsed
> > back down to single path in the face of reservations, so it would
> > probably be better simply to use failover in the face of reservations
> > and clustering.
> 
> Why do you imply that you're down to a single path ? With multiple port
> devices, and the T10 unclarity on multiport support, simple reservations
> didn't bring you down to the single port access you are describing. Some
> devices may have implemented it this way, but the standard didn't say they
> had to or even that they should.
> 
> And this picture changes significantly with the use of Persistent
> Reservations and the use of keys.
> 

It appears you are mixing port and path. If you have multiple paths to a
port created by multiple adapters connecting to this port through a bus,
fabric, etc. then simple reservations should restrict you to only one
path to this port. Is there a device that implements simple reservations
and allows multiple initiators access?

-andmike
--
Michael Anderson
andmike@us.ibm.com

