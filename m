From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] mode pages for ATA/ATAPI devices via libata
Date: Fri, 13 May 2005 15:19:39 +1000
Message-ID: <428438EB.6050400@torque.net>
References: <200505111842.j4BIgHY8019500@falcon30.maxeymade.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:41104 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262241AbVEMFTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 01:19:43 -0400
In-Reply-To: <200505111842.j4BIgHY8019500@falcon30.maxeymade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, Albert CC Lee <albertcc@tw.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Doug Maxey wrote:
> ahem, the neural pathways are not just worn, they have become ruts. =) 
> 
> s/mode/vpd/.
> 
> On Wed, 11 May 2005 13:01:25 CDT, Doug Maxey wrote:
> 
>>Howdy,
>>
>>When a ATA/ATAPI device is attached via libata, what should the handling 
>>be for mode pages that do not exist in the device?
>>
>>Assuming the page being asked for is 0x83, should libata fake up the
>>page from the IDENTIFY (PACKET) DEVICE data?  Or should it just respond
>>there is no page 0x83 as it does now in INQUIRY?  Likewise for 0x80?

Doug,
For ATAPI, the packet interface is almost always
carrying a SCSI command set (exceptions anybody??),
typically MMC (for CD/DVD drives). Recent SPC-3 drafts
(to which MMC-4,5 should comply) have made the device
identification VPD page (0x83) mandatory. I haven't
seen any compliance yet (or for that matter a drive that
implements feature 0x108: LU serial number).

For ATA, work is being done on a SCSI-ATA Translation
draft standard see:
http://www.t10.org/ftp/t10/drafts/sat/sat-r03.pdf
section 8.1.3.3 .

Doug Gilbert
