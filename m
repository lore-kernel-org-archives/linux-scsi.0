From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Sat, 01 Apr 2006 12:31:15 +0200
Message-ID: <442E5673.30808@s5r6.in-berlin.de>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com> <20060329091104.GB7940@infradead.org> <442B15F4.30506@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43719 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751069AbWDAKdA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 05:33:00 -0500
In-Reply-To: <442B15F4.30506@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian King <brking@us.ibm.com>, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote on 2006-03-30:
> James Bottomley wrote:
>> This really doesn't look correct.  What you want is a sata transport
>> class with a max command length in the host device.
> 
> Christoph Hellwig wrote:
>> this sounds wrong to me.  cdb length is a limitation of the host 
>> (driver).
>> A target will reject unknown commands, no matter what length they have.
> 
> In practice, CDB length may be limited by both the host and the device. 
>  This applies to ATAPI, and some USB storage too IIRC.  For ATAPI, you 
> read the CDB length from the device's IDENTIFY PACKET DEVICE info page.

BTW, in case of SBP-2 devices, the CDB length is a property of the 
logical unit and is read from the IEEE 1394 node's configuration ROM. 
Linux' sbp2 driver implements only a CDB length of 12 bytes though.
-- 
Stefan Richter
-=====-=-==- -=-- ----=
http://arcgraph.de/sr/
