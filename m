From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Low-level reformat with different sector size: ?
Date: Fri, 29 Jun 2007 22:04:13 -0400
Message-ID: <4685BA1D.60805@torque.net>
References: <f638pe$it6$1@sea.gmane.org> <1183132245.3518.28.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39716 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbXF3CEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2007 22:04:37 -0400
In-Reply-To: <1183132245.3518.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthias Urlichs <matthias@urlichs.de>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2007-06-29 at 15:34 +0000, Matthias Urlichs wrote:
>> Yesterday I managed to buy a couple of SCA disks with a sector size of ...
>> *drumroll* ... 524.
>>
>> What's the easiest way to re-format these to use 512 bytes?
>> Preferably without screwing up anything else on these things?
> 
> We use this program go reformat 520 sector size disks back to 512:
> 
> http://parisc-linux.org/~jejb/blk512-linux.c
> 
> It should work for your device as well.  Beware it requires a complete
> low level format to achieve this, which can take a very long time.

I might mention at this point that sg_format is derived
from blk512-linux.c . Both should be able to format recent
SCSI disks (e.g. manufactured in this millennium). sformat
is an older program. All of them invoke the SCSI FORMAT
command. If the SCSI FORMAT command is examined in SCSI-2,
SBC, SBC-2 and SBC-3 then it can be seen as quite complex.
Over the 15 year period spanned by those standards (SBC-3 is
still a draft) it has become more complex and changed
somewhat.

The first terabyte SCSI disk was announced this week. I
wonder how long it takes to format.

Doug Gilbert
