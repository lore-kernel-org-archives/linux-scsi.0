From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [ANNOUNCE]: Target drivers for QLogic Fibre Channel cards released
Date: Tue, 08 Jul 2008 15:58:35 -0400
Message-ID: <4873C6EB.9080207@garzik.org>
References: <4873BCD5.5060407@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45673 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946AbYGHT6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2008 15:58:40 -0400
In-Reply-To: <4873BCD5.5060407@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

Vladislav Bolkhovitin wrote:
> I'm glad to announce that version 1.0.0 of target drivers for QLogic 
> Fibre Channel cards released and available for download from 
> http://scst.sourceforge.net/downloads.html.
> 
> Two target drivers were released:
> 
>   - Target driver qla2x00t for 22xx and 23xx based QLogic Fibre Channel 
> cards
> 
>   - Target driver qla_isp for 24xx based QLogic Fibre Channel cards
> 
> Those drivers are designed to work in SCST environment. They are high 
> performance drivers, which provide all necessary functionality to work 
> as targets in Fibre Channel environment.
> 
> Detail description of the target drivers you can find on SCST home page 
> http://scst.sourceforge.net.
> 
> Driver qla2x00t is being prepared in form of patch for review and 
> inclusion into the kernel.

Cool.  I'm looking forward to figuring out how to enable ATA target mode 
in a similar manner...  sata_mv and some ahci chips support ATA target mode.

	Jeff



