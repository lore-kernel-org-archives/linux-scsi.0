From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 06/64] libfc: Export FC headers
Date: Fri, 28 Aug 2009 09:58:49 -0700
Message-ID: <1251478729.3384.127.camel@fritz>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
	 <20090825205858.1553.17654.stgit@localhost.localdomain>
	 <20090827102739.GC5125@schmichrtp>  <1251394937.3384.72.camel@fritz>
	 <1251448366.4339.8.camel@swen.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZH1Q6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2009 12:58:47 -0400
In-Reply-To: <1251448366.4339.8.camel@swen.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "swen@vnet.ibm.com" <swen@vnet.ibm.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "; christopher.leech"@intel.com

On Fri, 2009-08-28 at 01:32 -0700, Swen Schillig wrote:
> On Thu, 2009-08-27 at 10:42 -0700, Robert Love wrote:
> > On Thu, 2009-08-27 at 03:27 -0700, Christof Schmitt wrote:
> > > On Tue, Aug 25, 2009 at 01:58:58PM -0700, Robert Love wrote:
> > > > Export fc_els.h, fc_fs.h, fc_gs.h and fc_ns.h so that they
> > > > may be used by applications.
> > > > 
> > > > This will be needed for FC Passthrough applications like fcping,
> > > > but could be used by other applications.
> > > 
> > > Are there already plans to implement tools like fcping? I have heard
> > > people thinking about the idea, but i am not aware of a project
> > > working on this.
> > > 
> > Yeah, we have an implementation in our fcoe-utils package. You can
> > download that package here- git://open-fcoe.org/openfc/fcoe-utils.git.
> > 
> > //Rob
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hi Rob
> 
> Are there any plans to extend your fcoe-utils package with some more
> tools or functionality ?
> Maybe something like fctrace, ...
> 
There aren't any specific plans for new user space tools at the moment.
Most of our time is being spent on adding functionality to libfc,
libfcoe and fcoe. We're also making some improvements to the other tools
in fcoe-utils that you might not care about as much. fcoeadm (interacts
with fcoe.ko) and fcoemon (DCB monitoring ans fcoe system service
daemon) are the primary applications in that package.

Regarding other applications- Chris Leech is working on patches to add
more registration commands (to the directory server) to libfc and to
test those changes he has a modified fcping to do directory server
queries, using FC passthrough. We'll probably check that tool in too.

> If so, would you be interested in code contributions in this area ?
> Not sure about legal so far, but will see.
> 
I would definitely be interested contributions. fctrace would be great.
Also, if you want to patch fcping or another application so that it
works with ZFCP I'd be glad to accept those patches too.

//Rob

