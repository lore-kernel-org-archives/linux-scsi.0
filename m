From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 02/17] lpfc: NVME Initiator: Base modifications Part A
Date: Wed, 18 Jan 2017 18:34:02 -0800
Message-ID: <af9d3d56-2239-232c-7317-7ae0ec25be90@gmail.com>
References: <587ec2ed.BwM2pzG0hT3uy4dN%jsmart2021@gmail.com>
 <20170118094921.GB3514@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34879 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdASCeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 21:34:06 -0500
Received: by mail-qt0-f195.google.com with SMTP id f4so5792149qte.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2017 18:34:06 -0800 (PST)
In-Reply-To: <20170118094921.GB3514@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org



On 1/18/2017 1:50 AM, Johannes Thumshirn wrote:

>> @@ -4959,11 +4968,11 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
>>   	int status;
>>   
>>   	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
>> -	if (!rdata || !rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
>> -		return FAILED;
> OK, I don't get this hunk. lpfc_rport_data_from_scsi_device() cannot return
> NULL anymore?
>
> I at least expected something like:
>
>    	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
> 	if (!rdata || !rdata->pnode)
> 		return FAILED;
> 	
> 	pnode = rdata->pnode;
> 	if (!NLP_CHK_NODE_ACT(pnode)
> 		return FAILED;

it can and the order of precedence for the if check allows for it. I 
don't see any difference in what you wrote vs what's there, other than 
pnode gets an assignment.


Agree with all your other comments and will address them.

-- james


