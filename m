From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 00/23] ncr5380: Eliminate macros, reduce code duplication,
 fix bugs etc
Date: Wed, 23 Mar 2016 12:35:36 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1603231220050.20655@nippy.intranet>
References: <20160321023149.604138431@telegraphics.com.au> <201603222324.27594.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:37393 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbcCWBgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 21:36:22 -0400
In-Reply-To: <201603222324.27594.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>, Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sam Creasey <sammy@sammy.net>


On Tue, 22 Mar 2016, Ondrej Zary wrote:

> Tested on HP C2502 (53C400A chip), Canon FG2-5202 (53C400 chip) and 
> DTC-3181L (DTCT-436P chip) ISA cards - everything works fine!
> 
> Thanks.

Thanks for testing, Ondrej.

> 
> Tested-by: Ondrej Zary <linux@rainbow-software.org>

Hannes, would you please take a look at patches 04/23, 14/23, 20/23 and 
23/23 when convenient? These four patches need a "reviewed-by" tag.

-- 
