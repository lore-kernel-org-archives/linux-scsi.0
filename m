From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: dev_loss_tmo behavior question
Date: Fri, 30 Jul 2010 15:15:51 -0700
Message-ID: <20100730221551.GI12731@plapp.qlogic.org>
References: <4C4F4B94.1070009@cs.wisc.edu>
 <4C5055AA.7080703@emulex.com>
 <20100728165707.GA9844@plapp.qlogic.org>
 <4C530A2D.5070507@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:6802 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0G3WPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2010 18:15:52 -0400
Content-Disposition: inline
In-Reply-To: <4C530A2D.5070507@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@Emulex.Com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, "Love, Robert W" <robert.w.love@intel.com>, Jing Huang <huangj@Brocade.COM>

On Fri, 30 Jul 2010, Mike Christie wrote:

> On 07/28/2010 11:57 AM, Andrew Vasquez wrote:
> > I'm curious though, each driver would still need to seed the rport's
> > dev_loss_tmo value (in the case of qla2xxx,
> > ha->port_down_retry_count), but, by doing so after rport-addition
> > (fc_remote_port_add()), the driver could still overwrite a previous
> > sysfs setting.  Internally, upon rport creation, the dev_loss_tmo
> > value is seeding with fc_dev_loss_tmo (a module parameter -- 60
> > seconds).  Should we extend the transport so the the 'default seeding
> > value' can be specified once at fc_host creation-time?
> >
> 
> I was going to add a fc_transport callout that gets called when the 
> rport is allocated so drivers can do other rport initialization if they 
> wanted. It is only called the first time when it is actually allocated 
> not every time fc_remote_port_add is called. Would that be more useful?

I'm fine with that too...

-- av
