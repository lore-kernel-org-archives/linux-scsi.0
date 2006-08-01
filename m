From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 2/6] lpfc 8.1.7 : Fix failing firmware download due to
 mailbox delays needing to be longer
Date: Tue, 01 Aug 2006 09:43:01 -0400
Message-ID: <44CF5A65.20908@emulex.com>
References: <1154432023.18162.13.camel@localhost.localdomain> <200608011420.41752.eike-kernel@sf-tec.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40407 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161375AbWHANnJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Aug 2006 09:43:09 -0400
In-Reply-To: <200608011420.41752.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org


Rolf Eike Beer wrote:
> James Smart wrote:
>> Fix failing firmware download due to mailbox delays needing to be longer.
> 
>>  		/* timeout active mbox command */
>> -		mod_timer(&psli->mbox_tmo, jiffies + HZ * LPFC_MBOX_TMO);
>> +		mod_timer(&psli->mbox_tmo, (jiffies +
>> +			       (HZ * lpfc_mbox_tmo_val(phba, mb->mbxCommand))));
>>  	}
> 
> In linux/jiffies.h there are some functions for converting jiffies to *secs 
> and back which you might find useful.

Ok - but we're not really converting jiffies to seconds here...

-- james
