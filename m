From: Jeff Woods <jdw@apple2.com>
Subject: Re: [PATCH] nuke some junk from the pcmcia scsi drivers
Date: Fri, 08 Aug 2003 16:18:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.2.0.9.0.20030808161151.029e9e00@mail.speakeasy.net>
References: <20030808191050.GD17983@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail15.speakeasy.net ([216.254.0.215]:14014 "EHLO
	mail.speakeasy.net") by vger.kernel.org with ESMTP id S271885AbTHHXSL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2003 19:18:11 -0400
In-Reply-To: <20030808191050.GD17983@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

At +0200 09:10 PM 8/8/2003, Christoph Hellwig wrote:
>DEV_STALE_* is used for some crude hacks in pcmcia netdrivers and it
>seems people copied it blindly over to the scsi ones also it couldn't
>ever be triggered (dev_link_t.open is never incremented e.g.)

I'm totally unfamiliar with the code involved, but it occurs to me that 
there may be dependencies in the SCSI drivers for PCMCIA code due to 
PCMCIA-based SCSI adapters (e.g., Adaptec 1480).  Someone may need to 
confirm if the DEV_STALE_* references are there to handle PCMCIA-SCSI adapters.

--
Jeff Woods <jdw@apple2.com>
Adaptec 1480 user


