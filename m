From: Ken Schneider <kschneider@bout-tyme.net>
Subject: RE: new driver
Date: Wed, 18 Feb 2004 18:57:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077148668.14308.6.camel@pc1.bout-tyme.net>
References: <7076215DFAA4574099E5CD59FE4222620427ACDF@pcssrv42.pcs.pc.ome.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from user224.net1222.fl.sprint-hsd.net ([69.68.131.224]:51845 "EHLO
	pc1.bout-tyme.net") by vger.kernel.org with ESMTP id S267092AbUBRX54
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 18:57:56 -0500
In-Reply-To: <7076215DFAA4574099E5CD59FE4222620427ACDF@pcssrv42.pcs.pc.ome.toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: Arjan van de Ven <arjanv@redhat.com>, "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>, "Jarrett, Peter B." <Peterj@lsil.com>

On Wed, 2004-02-18 at 18:39, Tomita, Haruo wrote:
> Hi ken,
> 
> Eric> There was an effort I started to open source some of
> Eric> the driver, which was linked to a pre-compiled library. 
> 
> Haruo> The pre-compiled library(megaide_lib.o) is included. 
> 
> Arjan> Then the driver is not available under the terms of the GPL.... 
> Arjan> (and not compatible with the kernel license so inclusion is not possible)
>  
> Ken> And therefore should not any reference to the GPL in the 
> Ken> other files. I think this should be all or nothing.
> 
> Is it that the source code of megaide_lib.o should be opened?

I was told by people on another list that if any part is closed the
entire package will not be included in the kernel tree. So yes
negaide.lib.o should be open sourced or LSI should provide drivers to
linux users as well as any other platform that uses their hardware.

-- 
Ken Schneider <kschneider@bout-tyme.net>

