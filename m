From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi-sysfs: correct errno for host_reset
Date: Wed, 16 Aug 2017 21:11:03 -0400
Message-ID: <yq1valnngm0.fsf@oracle.com>
References: <20170810175212.GA19528@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28569 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdHQBLP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 21:11:15 -0400
In-Reply-To: <20170810175212.GA19528@localhost.didichuxing.com> (weiping
        zhang's message of "Fri, 11 Aug 2017 01:52:17 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


weiping,

> if scsi_host_template->host_reset is NULL, when user "echo adapter >
> /sys/class/scsi_host/hostx/host_reset", -EINVAL will return even
> string compare successfully. It make user confuse.
>
> change to:
> -EINVAL		if string not match "adapter" / "firmware";
> -EOPNOTSUPP	if string match but not implement ->host_reset.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
