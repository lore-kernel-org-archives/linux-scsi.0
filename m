From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Sun, 17 Feb 2008 13:15:40 -0800
Message-ID: <20080217211539.GA29813@tpepper-t42p.dolavim.us>
References: <20080215225057.GA3172@tpepper-t42p.dolavim.us> <20080216094127E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42378 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYBQVPn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 16:15:43 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1HLFh5t019053
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 16:15:43 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1HLFh581072634
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 16:15:43 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1HLFgpt027741
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 16:15:43 -0500
Content-Disposition: inline
In-Reply-To: <20080216094127E.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Sat 16 Feb at 09:41:48 +0900 tomof@acm.org said:
> 
> Do you mean that you applied only the following two patches against
> 2.6.24, and then it doesn't work?
> 
> 0001-ips-revert-the-changes-for-the-data-buffer-accessor.patch

I only applies the 0001 patch and the driver appeared to function fine.

> If so, the second patch is broken. Did you saw BUG_ON message (I added
> some BUG_ON to the patch)?

I did not apply the 0002 patch.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
