From: "Praveen Murali" <pmurali@logicube.com>
Subject: Re: [PATCH 3/3] Fix device detection issues with mvsas driver
Date: Wed, 16 Oct 2013 19:57:24 -0700
Message-ID: <00E6420E-23BE-463F-A01B-F29B6D26B9D8@logicube.com>
References: <F766E4F80769BD478052FB6533FA745D4CEB81B63E@SC-VEXCH4.marvell.com> <CAP0P+NXi=owEOnpTAnKxwrHfX-nu+bQF6MeNs3sMZnQLqB1jsw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:46987 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432Ab3JQC5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 22:57:24 -0400
In-Reply-To: <CAP0P+NXi=owEOnpTAnKxwrHfX-nu+bQF6MeNs3sMZnQLqB1jsw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xiangliang yu <yxlraid@gmail.com>
Cc: dan.j.williams@intel.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, yuxiangl@marvell.com

The only way to reproduce this is to keep hot plugging drives. To speed it up once in a while remove the drive before the detection completes.

> On Oct 16, 2013, at 7:42 PM, "xiangliang yu" <yxlraid@gmail.com> wrote:
> 
> Hi,
> 
> >Subject: Re: [PATCH 3/3] Fix device detection issues with mvsas driver
> 
> >Hi Xiang, Can you please take a look at the attached patch and ack it?
> >	/* cleanup and prepare the allocated FIS index */
> >	memset( SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset), 0, 
> >				sizeof(struct dev_to_host_fis) );
> 
> According to spec, the FIS memory don't need to be cleared by software.
> can you tell me how to reproduce the issue? thanks!
> 
> 
