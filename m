From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2/2] fusion - honour return value of pci_enable_device()
 in mpt_resume()
Date: Fri, 16 Mar 2007 13:18:40 -0400
Message-ID: <45FAD170.50003@torque.net>
References: <20070316070521.GB1081@verge.net.au>	<20070316070550.GC1081@verge.net.au>	<1174055246.3519.5.camel@mulgrave.il.steeleye.com>	<20070316080647.3c6d3579.rdunlap@xenotime.net>	<1174061692.3519.6.camel@mulgrave.il.steeleye.com> <20070316082015.e7183c0e.rdunlap@xenotime.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56427 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965745AbXCPRSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2007 13:18:55 -0400
In-Reply-To: <20070316082015.e7183c0e.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Horms <horms@verge.net.au>, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>

Randy Dunlap wrote:
> On Fri, 16 Mar 2007 11:14:51 -0500 James Bottomley wrote:
> 
>> On Fri, 2007-03-16 at 08:06 -0700, Randy Dunlap wrote:
>>> On Fri, 16 Mar 2007 09:27:26 -0500 James Bottomley wrote:
>>>
>>>> On Fri, 2007-03-16 at 16:05 +0900, Horms wrote:
>>>>> +       err = pci_enable_device(pdev);
>>>>> +       if (err < 0)
>>>>> +               return err;
>>>> Traditionally, this should be 
>>>>
>>>> if (err)
>>>> 	return err;
>>>>
>>>> The reason is that <0 is a signed comparison which can be slightly more
>>>> expensive on some architectures and it's unnecessary if zero is the only
>>>> successful return.
>>> Tradition vs. Linus, eh?  Linus wrote (2007-Mar-06, on lkml,
>>> Message-ID: <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>):
>> Sure ... we can all maintain our own traditions .. what was the subject
>> of this email?
> 
> The subject was coding style and return/error codes.
> The Subject: line was: Re: [5/6] 2.6.21-rc2: known regressions

Randy,
While on the subject of traditions, how about the
C90 and C99 ones?

C identifiers starting with "__" are reserved!
Reference: ISO/IEC 9899:1999 (C99) section 7.1.3 "All
identifiers that start with an underscore and either
an upper case letter or another underscore are always
reserved for any use". It was the same in C90.

Now we might start getting rid of __u32 and its
friends first :-)

Doug Gilbert

