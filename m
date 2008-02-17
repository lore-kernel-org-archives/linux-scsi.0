From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Sun, 17 Feb 2008 13:16:41 -0800
Message-ID: <20080217211640.GB29813@tpepper-t42p.dolavim.us>
References: <20080215011636.GA21124@tpepper-t42p.dolavim.us> <20080216010954M.tomof@acm.org> <20080215225057.GA3172@tpepper-t42p.dolavim.us> <20080216094127E.tomof@acm.org> <47B82DFB.8010206@panasas.com> <47B831F2.90201@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42924 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbYBQVQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 16:16:44 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1HLGi5E019567
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 16:16:44 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1HLGiTs209070
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 16:16:44 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1HLGhTn028637
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 16:16:44 -0500
Content-Disposition: inline
In-Reply-To: <47B831F2.90201@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <tomof@acm.org>, lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Sun 17 Feb at 15:09:06 +0200 bharrosh@panasas.com said:
> > 
> > You just need to also check for sg != NULL in the for() loop.
> > 
> > Tim Please test below patch. It's ontop of 2.6.24 but should also apply to
> > 2.6.25-rcx


> Disregard that patch it is totally wrong. That's not it. Sorry
> 
> Boaz
> 

You sure?  I was about to give it a quick run...but I guess I wont then. :)

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
