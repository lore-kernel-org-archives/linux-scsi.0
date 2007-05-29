From: Hannes Reinecke <hare@suse.de>
Subject: cciss broken with 2.6.22-rc2
Date: Tue, 29 May 2007 14:01:23 +0200
Message-ID: <465C1613.4050600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbXE2MBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 May 2007 08:01:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mike,

with the latest git snapshot the cciss driver hangs during
initialisation. Enabling debug output I get:

cciss0: <0x3230> at PCI 0000:06:00.0 IRQ 4338 using DAC
Sending cff0000 - down to controller
cciss:  FIFO Empty read
cciss:  Read cff00000 back from board
Sending cff0000 - down to controller
cciss:  FIFO Empty read
cciss:  Read cff00002 back from board
LUN Data
--------------------------
Sending cff0000 - down to controller
cciss:  FIFO Empty read
cciss:  Read cff00000 back from board
      blocks=3D 286677120 block_size=3D 512
Sending cff0000 - down to controller
cciss:  FIFO Empty read
cciss:  Read cff00002 back from board
      heads=3D255, sectors=3D32, cylinders=3D35132

Sending 5103000 - down to controller

and then the machine hangs.
I'll try to investigate, but as I'm no expert in cciss my results might
be limited.
Looks like one of your recent fixes broke it; 2.6.21 worked fine.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
