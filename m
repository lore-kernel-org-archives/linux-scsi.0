From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: "gdth: update deprecated pci_find_device" is incorrect
Date: Thu, 14 Feb 2008 16:00:03 +0100
Message-ID: <47B45773.3090203@gmail.com>
References: <47B453D3.5060707@gmail.com> <47B45469.5070103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:31244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYBNPAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 10:00:09 -0500
Received: by fg-out-1718.google.com with SMTP id e21so236785fga.17
        for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 07:00:06 -0800 (PST)
In-Reply-To: <47B45469.5070103@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Sergio Luis <sergio@larces.uece.br>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 02/14/2008 03:47 PM, Jiri Slaby wrote:
> On 02/14/2008 03:44 PM, Jiri Slaby wrote:
>> Hi,
>>
>> commit
>> 99109301d103fbf0de43fc5a580a406c12a501e0
>> in jejb/scsi-rc-fixes-2.6.git is incorrect. You don't decrement pci 
>> refcount on exit. Also you do not so on fail paths... I wonder why 
>> these mistakes happen every second time somebody tries to do such change.
>>
>> It leaked into mainline yet after "whole" two days, but what exactly 
>> drives me crazy is, that Jeff commented it in similar way and nobody 
>> reflected it!

Yeah, you did (I read the thread on wrong server obviusly), sorry...
