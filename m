From: Stefan Smietanowski <stesmi@stesmi.com>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Fri, 26 Mar 2004 11:14:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4064027D.30704@stesmi.com>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de>	 <20040325082949.GA3376@gondor.apana.org.au>	 <20040325220803.GZ16746@fs.tum.de>  <40635DD9.8090809@pobox.com>	 <1080260235.3643.103.camel@imladris.demon.co.uk>	 <4063EEC1.9080203@stesmi.com> <1080294208.27237.2.camel@LNX.iNES.RO>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 1-2-2-1a.has.sth.bostream.se ([82.182.130.86]:64166 "EHLO
	K-7.stesmi.com") by vger.kernel.org with ESMTP id S263999AbUCZKPe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 05:15:34 -0500
In-Reply-To: <1080294208.27237.2.camel@LNX.iNES.RO>
List-Id: linux-scsi@vger.kernel.org
To: Dumitru Ciobarcianu <Dumitru.Ciobarcianu@ines.ro>
Cc: David Woodhouse <dwmw2@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, Adrian Bunk <bunk@fs.tum.de>, 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Dumitru.

>>/*
>>     This file is under the GPL, yada yada
>>*/
>>#include "things.h"
>>
>>void some_func(void)
>>{
>>   does_something();
>>}
>>
>>char firmware[]={0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
>>
>>void upload_firmware(void)
>>{
>>   do_upload(firmware);
>>}
>>
>>--
>>
>>Then it seems clear to me that the firmware is under the GPL because it
>>is PART of the GPL'd file.
> 
> 
> 
> If you're right, then the "binary" of the firmware it's GPL, not the
> source of the firmware, because that's what you have in this case :)
> 
> You can have that ? GPL the binary but not the source ? :)

Not as far as I know, you can't put the resulting binary under a
different license than the source, but hey, IANAL :)

That would make all sorts of nasty implications if it was possible.

// Stefan
