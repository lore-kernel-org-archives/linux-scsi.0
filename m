From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: new driver
Date: Thu, 19 Feb 2004 00:32:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40344A7A.5040909@pobox.com>
References: <7076215DFAA4574099E5CD59FE4222620427ACDF@pcssrv42.pcs.pc.ome.toshiba.co.jp> <1077148668.14308.6.camel@pc1.bout-tyme.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36060 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264310AbUBSFdF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 00:33:05 -0500
In-Reply-To: <1077148668.14308.6.camel@pc1.bout-tyme.net>
List-Id: linux-scsi@vger.kernel.org
To: Ken Schneider <kschneider@bout-tyme.net>
Cc: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>, Arjan van de Ven <arjanv@redhat.com>, "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>, "Jarrett, Peter B." <Peterj@lsil.com>

Ken Schneider wrote:
> On Wed, 2004-02-18 at 18:39, Tomita, Haruo wrote:
> 
>>Hi ken,
>>
>>Eric> There was an effort I started to open source some of
>>Eric> the driver, which was linked to a pre-compiled library. 
>>
>>Haruo> The pre-compiled library(megaide_lib.o) is included. 
>>
>>Arjan> Then the driver is not available under the terms of the GPL.... 
>>Arjan> (and not compatible with the kernel license so inclusion is not possible)
>> 
>>Ken> And therefore should not any reference to the GPL in the 
>>Ken> other files. I think this should be all or nothing.
>>
>>Is it that the source code of megaide_lib.o should be opened?
> 
> 
> I was told by people on another list that if any part is closed the
> entire package will not be included in the kernel tree. So yes
> negaide.lib.o should be open sourced or LSI should provide drivers to
> linux users as well as any other platform that uses their hardware.


Correct.  Drivers must be 100% open source, or they are not included in 
Linux.

This is dictated by the GNU General Public License, under which all 
kernel code is licensed.

	Jeff



