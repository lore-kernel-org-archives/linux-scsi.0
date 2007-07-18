From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Wed, 18 Jul 2007 16:32:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707181632200.5385@fbirervta.pbzchgretzou.qr>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37848 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXGROcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 10:32:47 -0400
In-Reply-To: <20070716162206.392129000@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>, Jens Axboe <jens.axboe@oracle.com>


On Jul 16 2007 18:15, Geert Uytterhoeven wrote:
>
>Add a Disk Storage Driver for the PS3:
>  - Implemented as a block device driver with a dynamic major
>  - Disk names (and partitions) are of the format ps3d%c(%u)
>  - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
>    doesn't support scatter-gather

I wonder what virtualization has to do with a block device driver?


	Jan
-- 
