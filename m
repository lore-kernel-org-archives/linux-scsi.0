From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2 resend] libata:fix kernel panic when hotplug
Date: Mon, 20 Jun 2016 21:22:03 -0400
Message-ID: <yq160t35oas.fsf@sermon.lab.mkp.net>
References: <1466052340-25520-1-git-send-email-dingxiang@huawei.com>
	<20160616202045.GF3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26137 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbcFUBWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2016 21:22:23 -0400
In-Reply-To: <20160616202045.GF3262@mtj.duckdns.org> (Tejun Heo's message of
	"Thu, 16 Jun 2016 16:20:45 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: DingXiang <dingxiang@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, fangwei1@huawei.com, miaoxie@huawei.com, wangyijing@huawei.com, zhangaihua1@huawei.com, zhaohongjiang@huawei.com, houtao1@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:

>> In fact,we don't need libata to deal with hotplug in sas environment.
>> So we can't run ata hotplug task when ata port is sas host.

Tejun> Martin, can you please confirm whether the above is true.  If so,
Tejun> I'll route the patch through libata w/ stable cc'd.

Not exactly a libsas expert. James? Dan?

-- 
Martin K. Petersen	Oracle Linux Engineering
