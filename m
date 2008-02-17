From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Sun, 17 Feb 2008 15:29:58 -0800
Message-ID: <20080217232957.GA30778@tpepper-t42p.dolavim.us>
References: <20080215225057.GA3172@tpepper-t42p.dolavim.us> <20080216094127E.tomof@acm.org> <20080217211539.GA29813@tpepper-t42p.dolavim.us> <20080218073134A.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41821 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbYBQXaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 18:30:03 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1HNU0E6023500
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 18:30:00 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1HNU0UQ236216
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 18:30:00 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1HNTxsu001060
	for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 18:30:00 -0500
Content-Disposition: inline
In-Reply-To: <20080218073134A.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Mon 18 Feb at 07:31:56 +0900 tomof@acm.org said:
> 
> Can you apply the 0001 and 0002 against 2.6.24 and see how it works?
> If it works well, then please apply the 0001, 0002 and 0003.
> 
> Please the patches in a step-by-step way and tell me which patch
> breaks the driver.

I wasn't thinking Friday...we already expected 0001 to fix it, so the
hope is one of the others breaks it and that is useful info.  I'll apply
and test the rest of the series.  Sorry!

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
