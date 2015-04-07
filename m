From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 10/21] lpfc: Fix provide host name and OS name in RSNN-NN
 FC-GS command
Date: Tue, 7 Apr 2015 15:23:26 -0400
Message-ID: <55242EAE.6000100@emulex.com>
References: <1428095522.6933.38.camel@myfc17> <20150405140748.00007e42@localhost>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:27740 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbDGTXw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:23:52 -0400
In-Reply-To: <20150405140748.00007e42@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org


On 4/5/2015 8:07 AM, Sebastian Herbszt wrote:
> James Smart wrote:
>> +	/* Note :- OS name is "Linux" as per requirement BZ168199. */
>> +	if (size < n)
>> +		return n;
>> +	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
>> +
>>   	return n;
>>   }
> Care to disclose which bugzilla contains BZ168199?
>
>

It's meaningless as it's Emulex's bugzilla database, per our own 
requirements.  You will see in the v3 patches just posted I just nixed this.

-- james s


