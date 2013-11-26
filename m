From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ipr: Bugfix: add null pointer check for ioa_cfg
Date: Tue, 26 Nov 2013 11:20:54 -0600
Message-ID: <5294D876.8040105@linux.vnet.ibm.com>
References: <1384311737-1663-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33903 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab3KZRU7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Nov 2013 12:20:59 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 26 Nov 2013 12:20:58 -0500
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 07D1438C804D
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2013 12:20:54 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAQHKtZZ7405972
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2013 17:20:55 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAQHKtb0009206
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2013 12:20:55 -0500
In-Reply-To: <1384311737-1663-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, "James E.J. Bottomley" <JBottomley@parallels.com>, Wen Xiong <wenxiong@us.ibm.com>

On 11/12/2013 09:02 PM, Mike Qiu wrote:
> When we detects EEH errors during driver probe time, the error
> handlers of the driver are invoked by EEH core. Unfortunately,
> we haven't built some data structs that the error handlers
> refers to. That leads to kernel crash eventually.

This will only fix the kernel crash and not allow for recovery.
Wendy is working on a patch to support recovering from these
early EEH errors, so I'd prefer to wait and just push the one
patch, rather than have to revert this one once Wendy's
patch is ready.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


