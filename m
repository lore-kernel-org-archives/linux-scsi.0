From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: logging_level: update bits description
Date: Wed, 11 Oct 2017 15:18:27 +0200
Message-ID: <ccfbbfed-b1e4-2db8-12a4-76d083f0a474@linux.vnet.ibm.com>
References: <7d747a9b-e0a0-0f64-f1f3-66338ec7bbea@infradead.org>
 <216D3DB1-C329-4B75-8210-822FF889C344@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752029AbdJKNSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Oct 2017 09:18:36 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9BDFYMA100552
        for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2017 09:18:35 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dhgmkpgxr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2017 09:18:32 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Wed, 11 Oct 2017 14:18:31 +0100
In-Reply-To: <216D3DB1-C329-4B75-8210-822FF889C344@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle Fortin <kyle.fortin@oracle.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>


On 10/10/2017 09:32 PM, Kyle Fortin wrote:
> On Oct 10, 2017, at 3:05 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Update the description of 'scsi_logging_level' from 8 4-bit nibbles
>> to the (pre-git) reality of 10 3-bit 'nibbles'.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> ---
>> drivers/scsi/scsi_logging.h |    8 ++++----
>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> --- lnx-414-rc3.orig/drivers/scsi/scsi_logging.h
>> +++ lnx-414-rc3/drivers/scsi/scsi_logging.h
>> @@ -3,10 +3,10 @@
>>
>>
>> /*
>> - * This defines the scsi logging feature.  It is a means by which the user
>> - * can select how much information they get about various goings on, and it
>> - * can be really useful for fault tracing.  The logging word is divided into

nit pick: Why reflow and thus "change" these 3 lines even though the 
content is the same?

>> - * 8 nibbles, each of which describes a loglevel.  The division of things is
>> + * This defines the scsi logging feature.  It is a means by which the user can
>> + * select how much information they get about various goings on, and it can be
>> + * really useful for fault tracing.  The logging word is divided into 10 3-bit
>> + * 'nibbles', each of which describes a loglevel.  The division of things is
> 
> I think ‘bitfields' is more appropriate than ‘nibbles’ (a 4-bit construct in compute).

+1

>>   * somewhat arbitrary, and the division of the word could be changed if it
>>   * were really needed for any reason.  The numbers below are the only place
>>   * where these are specified.  For a first go-around, 3 bits is more than
> 
> Reviewed-by: Kyle Fortin <kyle.fortin@oracle.com>

Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
