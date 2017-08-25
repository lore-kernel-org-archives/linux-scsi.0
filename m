From: Hannes Reinecke <hare@suse.de>
Subject: Re: qla2xxx: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041)
Date: Fri, 25 Aug 2017 11:00:53 +0200
Message-ID: <063278e2-f5ff-24f3-9b73-a2a05a4c5542@suse.de>
References: <alpine.LRH.2.20.1708192337130.26479@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54439 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755107AbdHYJAz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 05:00:55 -0400
In-Reply-To: <alpine.LRH.2.20.1708192337130.26479@math.ut.ee>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com

On 08/19/2017 10:41 PM, Meelis Roos wrote:
> Hello, I just tried Linux with the latest kernel (4.13-rc5+git) on a HP 
> DL360 G6 with HP branded ISP2432 HBA. The driver mentions unsupported 
> model of the card:
> 
> [    3.868589] scsi host1: qla2xxx
> [    3.871696] qla2xxx [0000:07:00.0]-00fb:1: QLogic HPAE312A - PCI-Express Dual Port 4Gb Fibre Channel HBA.
> [    3.871782] qla2xxx [0000:07:00.0]-00fc:1: ISP2432: PCIe (2.5GT/s x4) @ 0000:07:00.0 hdma+ host#=1 fw=8.03.00 (9496).
> [    3.871973] qla2xxx [0000:07:00.1]-001d: : Found an ISP2432 irq 49 iobase 0xffffc900062c5000.
> [    3.872568] qla2xxx [0000:07:00.1]-0034:4: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041).
> 
> Is there some information I can provide to include this card in fully 
> supported list?
> 
Weelll ... that statement indicates that MSI-X is unsupported, not the
card itself.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
