From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: RE: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI
 53C1030
Date: Sat, 18 Aug 2007 12:22:34 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0708181004430.14169@filesrv1.baby-dragons.com>
References: <664A4EBB07F29743873A87CF62C26D70916F09@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.system-techniques.com ([204.91.156.41]:58580 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047AbXHRTWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Aug 2007 15:22:36 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70916F09@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

 	Hello Eric ,

On Sat, 18 Aug 2007, Moore, Eric wrote:
> On Saturday, August 18, 2007 12:40 AM,  Mr. James W. Laferriere wrote:
>> drivers/message/fusion/mptbase.c:4656: error:
>> `PCI_VENDOR_ID_ATTO' undeclared (first use in this function)
>> drivers/message/fusion/mptbase.c:4656: error: (Each
>> undeclared identifier is reported only once
>> drivers/message/fusion/mptbase.c:4656: error: for each
>> function it appears in.)
>> make[3]: *** [drivers/message/fusion/mptbase.o] Error 1
>> make[2]: *** [drivers/message/fusion] Error 2
>> make[1]: *** [drivers/message] Error 2
>> make: *** [drivers] Error 2
>>
>
> Why aren't you not doing a pull on the scsi-misc git tree?

 	Because there is never (that I've found) a mention of the git tree in 
any (not just yours) patches submitted .  I really do wish that patches 
pull/push-ed from/to a particular git/svn/cvs tree included the location of the 
tree when posted to a community list .  This would (imo) really cut down on the 
,  'Where is this at' ?'s .  It appears that most maintainers ass-u-me that 
everyone reading a list knows everything s/he knows & does leaves out alot of 
assume'd data that a casual reader may have to do a great deal of digging to 
find .

> Your missing
> another patch I posted which updated the include/linux/pci_ids.h, having
> the PCI_VENDOR_ID_ATTO declared.

 	Cool ,  I'll do a pull for this .
 		Tnx ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
