From: "Doelfel, Hardy" <hdoelfel@lsil.com>
Subject: RE: new driver
Date: Wed, 18 Feb 2004 19:27:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF93EE@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36533 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267198AbUBSA1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 19:27:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>, Ken Schneider <kschneider@bout-tyme.net>, Arjan van de Ven <arjanv@redhat.com>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org, "Mukker, Atul" <Atulm@lsil.com>, "Jarrett, Peter B." <Peterj@lsil.com>

Hi Haruo,
the library will stay closed source. The header files are only meant to make
it easier to compile for different kernel versions.

Thanks
	Hardy

-----Original Message-----
From: Tomita, Haruo [mailto:haruo.tomita@toshiba.co.jp]
Sent: Wednesday, February 18, 2004 6:40 PM
To: Ken Schneider; Arjan van de Ven
Cc: Moore, Eric Dean; linux-scsi@vger.kernel.org; Doelfel, Hardy; Mukker,
Atul; Jarrett, Peter B.
Subject: RE: new driver


Hi ken,

Eric> There was an effort I started to open source some of
Eric> the driver, which was linked to a pre-compiled library. 

Haruo> The pre-compiled library(megaide_lib.o) is included. 

Arjan> Then the driver is not available under the terms of the GPL.... 
Arjan> (and not compatible with the kernel license so inclusion is not
possible)
 
Ken> And therefore should not any reference to the GPL in the 
Ken> other files. I think this should be all or nothing.

Is it that the source code of megaide_lib.o should be opened?

-- 
Haruo
