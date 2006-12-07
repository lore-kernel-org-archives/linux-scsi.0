From: Etienne.Vogt@obspm.fr
Subject: Re: [mptscsi] endless Domain Validation loop with external RAID
 enclosure
Date: Thu, 7 Dec 2006 18:14:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612071809390.27398@siolinb.obspm.fr>
References: <Pine.LNX.4.64.0611141502290.20450@siolinb.obspm.fr>
 <Pine.LNX.4.64.0611211024260.3878@siolinb.obspm.fr>
Reply-To: Etienne.Vogt@obspm.fr
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from siolinb.obspm.fr ([145.238.2.18]:57254 "EHLO siolinb.obspm.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162489AbWLGROq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Dec 2006 12:14:46 -0500
Received: from vogt (helo=localhost)
	by siolinb.obspm.fr with local-esmtp (Exim 3.36 #1 (Debian))
	id 1GsMpZ-00024V-00
	for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2006 18:14:45 +0100
In-Reply-To: <Pine.LNX.4.64.0611211024260.3878@siolinb.obspm.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



On Tue, 21 Nov 2006, Etienne.Vogt@obspm.fr wrote:

>> I am having trouble getting an external Brownie BR8600 SCSItoIDE RAID
>> enclosure to work on our new HP Proliant ML350 file server. The SCSI
>> controller used is the integrated HP LSI based MPT SCSI controller :
>> 
>> With linux kernel 2.6.18.1 (official kernel.org, no added patches), the 
>> mptspi module goes into endless domain validation retries.
>
> I just checked on the web site of the RAID system manufacturer
> (axus.com.tw) to see if they have released an updated firmware that
> could solve the problem and unfortunately this is not the case.
> These BR8600 RAID systems are already running the latest available
> firmware (1.16a).
> So I really need a solution to continue using these systems on recent
> 2.6 kernels.

I just checked with the new 2.6.19 kernel and the problem is gone, no
more endless domain validation retries, just the usual insults about
SCSI protocol errors while scanning the bus and then everyone seems
happy again.
Many thanks to whoever did the right fix !

-- 
 		Etienne Vogt (Etienne.Vogt@obspm.fr)
 		Observatoire de Paris-Meudon, France
