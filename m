From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Fri, 08 Oct 2004 11:38:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4166B475.3080707@pobox.com>
References: <4161A06D.8010601@rtr.ca>	<416547B6.5080505@rtr.ca>	<20041007150709.B12688@infradead.org>	<4165624C.5060405@rtr.ca>	<416565DB.4050006@pobox.com>	<4165A45D.2090200@rtr.ca>	<4165A766.1040104@pobox.com>	<4165A85D.7080704@rtr.ca>	<4165AB1B.8000204@pobox.com>	<4165ACF8.8060208@rtr.ca> 	<20041007221537.A17712@infradead.org>	<1097241583.2412.15.camel@mulgrave>  <4166AF2F.6070904@rtr.ca> <1097249266.1678.40.camel@mulgrave> <4166B37D.8030701@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42201 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270035AbUJHPio
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2004 11:38:44 -0400
In-Reply-To: <4166B37D.8030701@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mark Lord wrote:
> And the driver will need it's own copy in some versions anyway,
> since this driver will be used on much older/earlier kernels
> than just the ones with the latest libata stuff.


Typically that's done with an out-of-tree compatibility module, such as 
something like kcompat (http://sf.net/projects/gkernel/), which provides 
a modern driver API to older kernels.

	Jeff


