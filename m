From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/6] lpfc 8.1.7 : Adding statistics reset callback for
 FC transport
Date: Tue, 01 Aug 2006 09:40:34 -0400
Message-ID: <44CF59D2.8050003@emulex.com>
References: <1154432009.18162.12.camel@localhost.localdomain> <200608011414.51998.eike-kernel@sf-tec.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19927 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161073AbWHANku
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Aug 2006 09:40:50 -0400
In-Reply-To: <200608011414.51998.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org


Rolf Eike Beer wrote:
>> -/* FIX ME */
>> -	/*hs->SecondsSinceLastReset = (jiffies - lpfc_loadtime) / HZ;*/
>> +	hs->seconds_since_last_reset = (jiffies - psli->stats_start) / HZ;
> 
> Wraparound?

Ok - we should probably calculate it based on gettimeofday(). I'll update
and repost.

>> +	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
>                                 ^
> 
> No space here.

Will include this too...

-- james
