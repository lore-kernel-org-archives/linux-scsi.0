From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [RFC PATCH 0/9] RFC: handle queue_depth adjustments because of
 QUEUE_FULLs in scsi_error.c
Date: Thu, 03 Sep 2009 10:17:19 +0200
Message-ID: <1251965839.3728.1.camel@swen.mainz.de.ibm.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
	 <1251845853.27437.69.camel@vi2.jf.intel.com> <4A9DCE5D.2040208@cs.wisc.edu>
	 <1251914477.29277.101.camel@vi2.jf.intel.com>
Reply-To: swen@vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:41786 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZICIRo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2009 04:17:44 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate7.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n838HVSU290970
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 08:17:36 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n838HKuB2809938
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 09:17:21 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n838HKHv007534
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 09:17:20 +0100
In-Reply-To: <1251914477.29277.101.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Wed, 2009-09-02 at 11:01 -0700, Vasu Dev wrote:
> On Tue, 2009-09-01 at 20:46 -0500, Mike Christie wrote:
> > On 09/01/2009 05:57 PM, Vasu Dev wrote:
> 
> <snip>
> 
> > You should just post your patches with mine. I do not have time to test 
> > my stuff right now with the current kernel, and since you need them and 
> > are going to have to test your patches just make it easy for 
> > James/reviewers and send it all in one patchset so people do not have to 
> > search for dependencies.
> > 
> > For my patches just add your signed off after mine, since you are 
> > sending them and I had written them.
> 
> I'll get them out as per by your suggestions above, thanks.
> 
> > 
> > You can/should probably also pick up Christop's stuff too for him (zfcp 
> > patches).
> 
> Christof, I'm fine picking up your patch also, let me know if that is
> not fine with you.

Christof is currently on vacation, but I'm pretty sure he doesn't mind.
Please go ahead.

Cheers Swen
> 
> 	Thanks
> 	Vasu
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

