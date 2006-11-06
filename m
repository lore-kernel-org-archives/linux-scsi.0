From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Automatic LUN detectioning not working
Date: Mon, 06 Nov 2006 11:40:53 +0100
Message-ID: <1162809658.3160.205.camel@laptopd505.fenrus.org>
References: <20061106090702.GA8071@npjaco.netgroup.co.za>
	 <1162807123.3160.182.camel@laptopd505.fenrus.org>
	 <20061106100806.GA9343@npjaco.netgroup.co.za>
Reply-To: arjan@infradead.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31362 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750807AbWKFKk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 05:40:59 -0500
In-Reply-To: <20061106100806.GA9343@npjaco.netgroup.co.za>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaco van der Schyff <jvds@netgroup.co.za>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-11-06 at 12:08 +0200, Jaco van der Schyff wrote:
> Attached devices:
> Host: scsi0 Channel: 00 Id: 06 Lun: 00
> Vendor: PE/PV    Model: 1x6 SCSI BP      Rev: 1.0 
> Type:   Processor                        ANSI SCSI revision: 02
> Host: scsi0 Channel: 02 Id: 00 Lun: 00
> Vendor: MegaRAID Model: LD 0 RAID1  139G Rev: 521X
> Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
> Vendor: SA-6640S Model:                  Rev: R0.0
> Type:   Direct-Access                    ANSI SCSI revision: 03
> 
> The device is question is the SA-6640S on scsi1:0:0:0
> 
> http://www.maxtronic.com/raid_systems/janusraid_series/janusraid_sa-6640s/

ok this is curious; the device claims to be rev 3 scsi, so the kernel
will have used the "REPORT_LUNS" command, which asks the device to tell
the kernel which LUNs it has.. it seems it just plain lies if it doesnt'
work for you.



