From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Linux version 2.6.6 // libata 1.02 // sata_promise version 0.92
 // problem with Promise FastTrack S150 SX4
Date: Mon, 17 May 2004 14:06:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40A8FF29.7090701@pobox.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAA6/QqhRnc20Gp8M2IBiikcMKAAAAQAAAAoC6hppJpiEatjNFHGy82SgEAAAAA@nawan.hostinguk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:29073 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262003AbUEQSGp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 May 2004 14:06:45 -0400
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAA6/QqhRnc20Gp8M2IBiikcMKAAAAQAAAAoC6hppJpiEatjNFHGy82SgEAAAAA@nawan.hostinguk.com>
List-Id: linux-scsi@vger.kernel.org
To: Nicholas <kdev437@nawan.hostinguk.com>
Cc: linux-scsi@vger.kernel.org

Nicholas wrote:
> Hello,
>  I have compiled SCSI and libata support directly into a 2.6.6 kernel, in
> order to try and get the Linux kernel to recognise a two drive RAID0 array
> attached to a FastTrack S150 SX4. Unfortunately the drives are seen as two
> seperate drives, and the single RAID 0 array appears not to be detected. I
> am assuming this is not normal. The RAID0 array works fine under W2k. I have


This is normal.

Promise proprietary RAID is not supported under Linux, by the kernel 
drivers.

	Jeff



