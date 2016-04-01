From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 3/5] bnx2fc: Print netdev device name when FCoE is
 successfully initialized.
Date: Fri, 1 Apr 2016 10:08:22 -0400
Message-ID: <alpine.OSX.2.00.1604011007130.795@administrators-macbook-pro.local>
References: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com> <1459516223-32106-4-git-send-email-chad.dupuis@qlogic.com> <7007693da84d5e6613ba8c1ed321780b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:38856 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754531AbcDAOIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2016 10:08:36 -0400
In-Reply-To: <7007693da84d5e6613ba8c1ed321780b@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org


On Fri, 1 Apr 2016, Johannes Thumshirn wrote:

> On 2016-04-01 15:10, Chad Dupuis wrote:
>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>> ---
>>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> index d95eee6..60423cf 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> @@ -2044,6 +2044,8 @@ static void bnx2fc_ulp_init(struct cnic_dev *dev)
>>  		return;
>>  	}
>> 
>> +	pr_err(PFX "FCoE initialized for %s.\n", dev->netdev->name);
>> +
>>  	/* Add HBA to the adapter list */
>>  	mutex_lock(&bnx2fc_dev_lock);
>>  	list_add_tail(&hba->list, &adapter_list);
>
> I don't think KERN_ERR is the appropriate log level for this, can you change 
> it to pr_info()?
>

Yes, I'll change it to a pr_info in a V2 set.
