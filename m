From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.6-mm5
Date: Sat, 22 May 2004 05:09:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40AF18E7.4040509@pobox.com>
References: <20040522013636.61efef73.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37767 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264925AbUEVJKS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 05:10:18 -0400
In-Reply-To: <20040522013636.61efef73.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Morton wrote:
> - Added a new SATA RAID driver from 3ware.  From a quick peek it seem to
>   need a little work yet.


It's not too bad... but it looks more like a 2.2 driver forward ported 
to 2.4, than a 2.6.x driver.  Needs some luvin' from the 2.6 scsi api crew.

Overall, it appears to be a message-based firmware engine like 
drivers/block/carmel.c, that hides the SATA details in the firmware.

	Jeff


