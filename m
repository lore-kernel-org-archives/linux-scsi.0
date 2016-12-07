From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Wed, 7 Dec 2016 08:55:24 -0800
Message-ID: <d5b9960c-b68c-c636-dd1d-dfd056d99e52@sandisk.com>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
 <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584763FB.9010602@huawei.com>
 <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584784D7.1070009@huawei.com>
 <BLUPR02MB1683A85CB4376E9904F1B38881850@BLUPR02MB1683.namprd02.prod.outlook.com>
 <5847B355.2050100@huawei.com>
 <9d9b3296-09d8-0f65-f52d-33fc19c4b6c2@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:44096
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932912AbcLGQza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Dec 2016 11:55:30 -0500
In-Reply-To: <9d9b3296-09d8-0f65-f52d-33fc19c4b6c2@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/07/2016 08:48 AM, Bart Van Assche wrote:
> It's a known bug. Some time ago I posted a patch that serializes all
> scsi_device_set_state() calls but I have not yet found it in the list
> archives. However, that patch has not yet been merged.

See also https://www.spinics.net/lists/linux-scsi/msg66966.html.

Bart.

