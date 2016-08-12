From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH 2/2] be2iscsi: Fix some error messages
Date: Fri, 12 Aug 2016 22:30:29 +0200
Message-ID: <4cd24bc3-7953-479a-1dbe-2aac9299ce13@wanadoo.fr>
References: <1470996165-31131-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <alpine.DEB.2.10.1608121229310.2983@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1608121229310.2983@hadrien>
Sender: kernel-janitors-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: jayamohan.kallickal@avagotech.com, jejb@linux.vnet.ibm.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Le 12/08/2016 à 12:30, Julia Lawall a écrit :
> On Fri, 12 Aug 2016, Christophe JAILLET wrote:
>
>> This fixes:
>>     - missing spaces in string split on several lines
>>     - extra spaces after ':'
>>     - missing '\n' at the end of some messages
>>     - too long lines
> I think that the strings should be concatenated, even if they go past 80
> chars.  I'm surprised checkpatch didn't complain.
>
> julia

checkpatch did complain.
In this file, all logging messages were written with split lines when 
too long, so I considered that it was better to keep it like that.

I will resubmit if the patch gets some interest and if a maintainer ask 
for concatenated messages.

CJ

---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus

