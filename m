From: Spelic <spelic@shiftmail.org>
Subject: Re: mvsas errors in 2.6.36
Date: Thu, 02 Dec 2010 14:17:20 +0100
Message-ID: <4CF79C60.9030107@shiftmail.org>
References: <201010290650.32892.thomas@fjellstrom.ca>
 <4CE3912E.6060904@tomt.net> <201012012329.54944.thomas@fjellstrom.ca>
 <201012020249.00367.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:60615 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab0LBN6T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 08:58:19 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5 #31825) id <01NUY50EBL00LS7885@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Thu, 02 Dec 2010 14:17:23 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
 id <01NUY50B7FXSLVVSP7@mx.isti.cnr.it> for linux-scsi@vger.kernel.org; Thu,
 02 Dec 2010 14:17:20 +0100 (MET)
In-reply-to: <201012020249.00367.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/02/2010 10:48 AM, Thomas Fjellstrom wrote:
>
>>> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_
>>> pl
>>> ain;f=queue-2.6.33/libsas-fix-ncq-mixing-with-non-ncq.patch;h=b6d7c92094
>>> d95 ad67a3b23c2e09c25d4fbd0f46b;hb=HEAD
>>>
>>> The fix is queued up for the next 2.6.36 and 2.6.35 stable
>>> point-releases.
>>>        
>> Ahah. I wonder how I missed that when I first read it. I'll have to give
>> the stable .36 kernel a try. Thanks!
>>      
> No fix so far:
>    

If you tried v2.6.36 or v2.6.36.1 like you said you are not getting the 
above mentioned commit.
It's already applied only in 2.6.37-rc1..rc4
What version have you tried exactly?
