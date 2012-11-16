From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [scsi:misc 36/36] drivers/scsi/csiostor/csio_attr.c:92:41:
 sparse: incorrect type in assignment (different base types)
Date: Fri, 16 Nov 2012 22:58:19 +0800
Message-ID: <20121116145819.GC5726@localhost>
References: <50a53498.V1y2+GrYc8qRSL1F%fengguang.wu@intel.com>
 <50A61169.3010709@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21076 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab2KPO6c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2012 09:58:32 -0500
Content-Disposition: inline
In-Reply-To: <50A61169.3010709@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Naresh Kumar Inna <naresh@chelsio.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@Parallels.com>

Hi Naresh,

On Fri, Nov 16, 2012 at 03:41:53PM +0530, Naresh Kumar Inna wrote:
> On 11/15/2012 11:59 PM, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> > head:   0779fa137a73170b6c796fdb476f1455ba67b9aa
> > commit: 0779fa137a73170b6c796fdb476f1455ba67b9aa [36/36] [SCSI] csiostor: Chelsio FCoE offload driver
> > 
> > 
> > sparse warnings:
> > 
> 
> Thanks for your report.

My pleasure!

> My run of 'make C=2' to run sparse never reported these. Is there
> someway I can run your tool locally so I can clean up my next set of
> patches before sending them?
 
This will enable more sparse type checks:

make C=1 CF=-D__CHECK_ENDIAN__

> With respect to the warnings, will correct type-casting help me get rid
> of most of them?

As long as the type-casting is *correct* ;-) 

Thanks,
Fengguang
