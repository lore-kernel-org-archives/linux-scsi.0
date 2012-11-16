From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [scsi:misc 36/36] drivers/scsi/csiostor/csio_attr.c:92:41: sparse:
 incorrect type in assignment (different base types)
Date: Fri, 16 Nov 2012 15:41:53 +0530
Message-ID: <50A61169.3010709@chelsio.com>
References: <50a53498.V1y2+GrYc8qRSL1F%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:16081 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2KPKMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Nov 2012 05:12:03 -0500
In-Reply-To: <50a53498.V1y2+GrYc8qRSL1F%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@Parallels.com>

On 11/15/2012 11:59 PM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> head:   0779fa137a73170b6c796fdb476f1455ba67b9aa
> commit: 0779fa137a73170b6c796fdb476f1455ba67b9aa [36/36] [SCSI] csiostor: Chelsio FCoE offload driver
> 
> 
> sparse warnings:
> 

Thanks for your report.

My run of 'make C=2' to run sparse never reported these. Is there
someway I can run your tool locally so I can clean up my next set of
patches before sending them?

With respect to the warnings, will correct type-casting help me get rid
of most of them?

Regards,
Naresh.
