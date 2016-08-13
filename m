From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH 2/2 v3] be2iscsi: Fix some error messages
Date: Sat, 13 Aug 2016 14:31:01 +0200
Message-ID: <fdffed8e-d269-6519-437e-6f731dbb9c05@wanadoo.fr>
References: <4cd24bc3-7953-479a-1dbe-2aac9299ce13@wanadoo.fr>
 <1471072824-1491-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <1471088144.3467.11.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471088144.3467.11.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, jayamohan.kallickal@avagotech.com, jejb@linux.vnet.ibm.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Le 13/08/2016 à 13:35, Joe Perches a écrit :
>
>> @@ -268,7 +268,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>>   				&nonemb_cmd.dma);
>>   	if (nonemb_cmd.va == NULL) {
>>   		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
>> -			    "BM_%d : Failed to allocate memory for"
>> +			    "BM_%d : Failed to allocate memory for "
>>   			    "mgmt_invalidate_icds\n");
> doesn't match commit log as no coalescing/concatenation
> is done.
>
> There are many of these.
>
I have *only* fixed the one reported by checkpatch and left the others 
unchanged.

My initial proposal was to fix incorrect strings, without modifying too 
much the code. So I decided to do the minimum of changes.

Should I resubmitted with:
    - all strings *in the patch* concatenated?
    - all strings *in the file*" concatenated?

CJ


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
