From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Thu, 14 Feb 2008 17:16:36 -0800
Message-ID: <20080215011636.GA21124@tpepper-t42p.dolavim.us>
References: <20080213214324.GB18227@tpepper-t42p.dolavim.us> <20080214204838F.fujita.tomonori@lab.ntt.co.jp> <20080214235549.GA19591@tpepper-t42p.dolavim.us> <20080215091316H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:53436 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYBOBQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 20:16:39 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1F1GcVw009604
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 20:16:38 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1F1Gcsu156304
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 18:16:38 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1F1GbGl016514
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 18:16:38 -0700
Content-Disposition: inline
In-Reply-To: <20080215091316H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, tomof@acm.org

On Fri 15 Feb at 09:13:16 +0900 fujita.tomonori@lab.ntt.co.jp said:
> 
> Thanks. So we surely have a bug in the non-breakup part.
> 
> I've just found one bug. Can you try this patch against 2.6.24?

Tested and unfortunately no change.  Behaves same as the breakup-revert patch.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
