From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: areca [17d3:1320] controller not working with linux 3.5 and mvsas?!
Date: Thu, 16 Aug 2012 10:58:22 +0200
Message-ID: <502CB62E.1030609@powercraft.nl>
References: <502BE024.8000309@powercraft.nl> <668BF84A97B747B39C316D3D3F0CB017@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.cambriumhosting.nl ([217.19.16.173]:37048 "EHLO
	relay01.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222Ab2HPI60 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2012 04:58:26 -0400
In-Reply-To: <668BF84A97B747B39C316D3D3F0CB017@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: 'linux-scsi' <linux-scsi@vger.kernel.org>

Hi Jack.

On 16/08/12 03:07, Jack Wang wrote:
> Seems the all idenfy to the disk failed,
> And all phy add to port-0:0 looks stange.

# ARC-1320ix-16 logs with a clean rmmod mvsas and modprobe mvsas
http://paste.debian.net/183845/

I tried to get the older working Areca 1300ix-16 controller but sadly
they don=92t sell them any more... I need a working non-raid controller
for 16 disks. I don't get why Areca doesn=92t use and support mainline
drivers for there controllers?

Does somebody know how to fix the mvsas driver for the ARC-1320ix-16? (=
I
can't do the coding myself)

What do you guys recommend? I got about 14 days to fix the issue.

Kind regards,

Jelle
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
