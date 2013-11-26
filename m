From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ipr: Bugfix: add null pointer check for ioa_cfg
Date: Wed, 27 Nov 2013 01:24:56 +0800
Message-ID: <5294D968.8030407@linux.vnet.ibm.com>
References: <1384311737-1663-1-git-send-email-qiudayu@linux.vnet.ibm.com> <5294D876.8040105@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49785 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab3KZRZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2013 12:25:03 -0500
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <qiudayu@linux.vnet.ibm.com>;
	Wed, 27 Nov 2013 03:25:02 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id E66522BB0052
	for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2013 04:24:59 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAQH6uP39109936
	for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2013 04:06:56 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAQHOxPu027733
	for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2013 04:24:59 +1100
In-Reply-To: <5294D876.8040105@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, "James E.J. Bottomley" <JBottomley@parallels.com>, Wen Xiong <wenxiong@us.ibm.com>

On 11/27/2013 01:20 AM, Brian King wrote:
> On 11/12/2013 09:02 PM, Mike Qiu wrote:
>> When we detects EEH errors during driver probe time, the error
>> handlers of the driver are invoked by EEH core. Unfortunately,
>> we haven't built some data structs that the error handlers
>> refers to. That leads to kernel crash eventually.
> This will only fix the kernel crash and not allow for recovery.
> Wendy is working on a patch to support recovering from these
> early EEH errors, so I'd prefer to wait and just push the one
> patch, rather than have to revert this one once Wendy's
> patch is ready.

OK, this is just a workaround, as Wendy will solve this issue, better to 
wait her solution.

Thanks
Mike
>
> Thanks,
>
> Brian
>

