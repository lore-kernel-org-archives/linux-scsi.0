From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH 06/64] libfc: Export FC headers
Date: Fri, 28 Aug 2009 10:32:46 +0200
Message-ID: <1251448366.4339.8.camel@swen.mainz.de.ibm.com>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
	 <20090825205858.1553.17654.stgit@localhost.localdomain>
	 <20090827102739.GC5125@schmichrtp>  <1251394937.3384.72.camel@fritz>
Reply-To: swen@vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:59314 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZH1IdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 04:33:11 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate3.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n7S8WvUg577840
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 08:33:02 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7S8Wlhl3305484
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 09:32:47 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7S8WkiY029669
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 09:32:47 +0100
In-Reply-To: <1251394937.3384.72.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2009-08-27 at 10:42 -0700, Robert Love wrote:
> On Thu, 2009-08-27 at 03:27 -0700, Christof Schmitt wrote:
> > On Tue, Aug 25, 2009 at 01:58:58PM -0700, Robert Love wrote:
> > > Export fc_els.h, fc_fs.h, fc_gs.h and fc_ns.h so that they
> > > may be used by applications.
> > > 
> > > This will be needed for FC Passthrough applications like fcping,
> > > but could be used by other applications.
> > 
> > Are there already plans to implement tools like fcping? I have heard
> > people thinking about the idea, but i am not aware of a project
> > working on this.
> > 
> Yeah, we have an implementation in our fcoe-utils package. You can
> download that package here- git://open-fcoe.org/openfc/fcoe-utils.git.
> 
> //Rob
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Rob

Are there any plans to extend your fcoe-utils package with some more
tools or functionality ?
Maybe something like fctrace, ...

If so, would you be interested in code contributions in this area ?
Not sure about legal so far, but will see.

Cheers Swen

