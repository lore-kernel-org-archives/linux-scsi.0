From: Jeff Garzik <jeff@garzik.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 10:36:57 -0400
Message-ID: <45F56589.1020209@garzik.org>
References: <45F48809.2060908@emc.com> <Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50674 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965891AbXCLOhC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Mar 2007 10:37:02 -0400
In-Reply-To: <Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>

Jan Engelhardt wrote:
> On Mar 11 2007 18:51, Ric Wheeler wrote:
>> During the recent IO/FS workshop, we spoke briefly about the
>> coming change to a 4k sector size for disks on linux. If I
>> recall correctly, the general feeling was that the impact was
>> not significant since we already do most file system IO in 4k
>> page sizes and should be fine as long as we partition drives
>> correctly and avoid non-4k aligned partitions.
> 
> Sorry about jumping right in, but what about an 'old-style'
> partition table that relies on 512 as a unit?

For 1K/4K physical sector size, where logical sector size remains 512-b, 
nothing changes.  DOS partitions start partitions on odd-numbered 
sectors, so presuming you have odd-aligned disks, life is good.

For 1K/4K logical sector sizes, who knows.  EFI?  <grins and runs>

Certainly seems incompatible with the current popular DOS partition format.

	Jeff



