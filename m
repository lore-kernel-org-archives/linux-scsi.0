From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH] lpfc: fix model description
Date: Thu, 28 May 2015 16:28:53 -0400
Message-ID: <55677A85.9070301@avagotech.com>
References: <20150422231618.00005ec8@localhost> <20150527234009.0000472c@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36232 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbbE1U25 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2015 16:28:57 -0400
Received: by qcxw10 with SMTP id w10so19453031qcx.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2015 13:28:55 -0700 (PDT)
In-Reply-To: <20150527234009.0000472c@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org

Yes - this is acceptable. Not a big deal per-say, but good to be uniform.

Reviewed-By: James Smart <james.smart@avagotech.com>

-- james s


On 5/27/2015 5:40 PM, Sebastian Herbszt wrote:
> I wrote:
>> Remove trailing space from model description.
>>
>> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
>>
>> diff -up 4.0/drivers/scsi/lpfc.orig/lpfc_init.c 4.0/drivers/scsi/lpfc/lpfc_init.c
>> --- 4.0/drivers/scsi/lpfc.orig/lpfc_init.c	2015-04-15 06:18:24.673045138 +0200
>> +++ 4.0/drivers/scsi/lpfc/lpfc_init.c	2015-04-22 21:03:39.203230409 +0200
>> @@ -2253,7 +2253,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba
>>   				phba->Port);
>>   		else if (max_speed == 0)
>>   			snprintf(descp, 255,
>> -				"Emulex %s %s %s ",
>> +				"Emulex %s %s %s",
>>   				m.name, m.bus, m.function);
>>   		else
>>   			snprintf(descp, 255,
> James,
>
> any feedback?
>
> Sebastian

