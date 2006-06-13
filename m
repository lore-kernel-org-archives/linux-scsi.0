From: Doug Maxey <dwm@bebe.enoyolf.org>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Tue, 13 Jun 2006 00:00:49 -0500
Message-ID: <20060613050049.781785@bebe.enoyolf.org>
References: <8889.1149988615@bebe.enoyolf.org> <448DACD5.6090205@cs.wisc.edu> <20060612211038.GB7555@ranandlinuxbox.qlogic.org> <448DDE31.2090300@cs.wisc.edu> <20060612224325.GK7555@ranandlinuxbox.qlogic.org> <20060613034851.320777@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:45763 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932825AbWFMFBT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 01:01:19 -0400
In-reply-to: <448E3FA8.4050309@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org


On Tue, 13 Jun 2006 00:31:36 EDT, Jeff Garzik wrote:
> Doug Maxey wrote:
> > Having a common solution (ala ethtool) for the user/admin, across all
> > SWI, all HBAs, and all distros would be optimal in my view.  Although
> > the QLogic tools are out there, they only work AFAIK, for the other,
> > non-mainline drivers.   It is enough pain to manage the targets,  
> > making one end of the configuration common would be a big bonus.
> 
> 
> Why, in fact...  that's the purpose of blktool :)

Eureka! You really are prescient. ;)

> 
> Vendor-specific code in blktool is quite welcome.  The general idea is 
> to manage various vendor-specific capabilities which fit common patterns.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/blktool.git
> http://sourceforge.net/projects/gkernel/

Will check it out.  Thank you.  

++Doug

