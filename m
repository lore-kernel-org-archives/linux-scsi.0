From: Ken Schneider <kschneider@bout-tyme.net>
Subject: Re: FW: new driver
Date: Wed, 18 Feb 2004 18:19:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077146393.14089.4.camel@pc1.bout-tyme.net>
References: <0E3FA95632D6D047BA649F95DAB60E5703EF9235@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from user224.net1222.fl.sprint-hsd.net ([69.68.131.224]:38021 "EHLO
	pc1.bout-tyme.net") by vger.kernel.org with ESMTP id S267144AbUBRXUA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 18:20:00 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703EF9235@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: atulm@lsil.com, linux-scsi@vger.kernel.org, arjanv@redhat.com, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>, "Jarrett, Peter B." <Peterj@lsil.com>

On Tue, 2004-02-17 at 10:51, Moore, Eric Dean wrote:
> I don't believe LSI Logic has opened
> sourced the MegaRAID IDEAL driver for inclusion
> into the generic kernel.
> If it has, its probably best to let this effort
> be driven by Atul Mukker<atulm@lsil.com>.
> 
> To my knowledge, this is a SCSI LLD in which 
> both the low-level hardware driver and 
> software raid are one driver.  There was
> an effort I started to open source some of
> the driver, which was linked to a pre-compiled
> library. I'm not sure of the current status
> as its been over a year since my involvement. 
> 
> Eric Moore
> Staff Engineer
> Standard Storage Products Division
> LSI Logic Corporation
> 4420 Arrowswest Drive
> Colorado Springs, CO 80907
> Email: emoore@lsil.com
> Web: http://www.lsilogic.com/
> 
> 

There is one library file in the package that I believe is not open
source. This one small file is causing the support of this controller to
-not- be included into the kernel tree.

Ultra ATA 100 LSI Logic controller.

-- 
Ken Schneider <kschneider@bout-tyme.net>

