From: kasture <mayuresh.kasture@gmail.com>
Subject: Writing to a sector listed in GList
Date: Tue, 11 Nov 2008 19:51:36 -0800 (PST)
Message-ID: <20453709.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:47644 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYKLDvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 22:51:37 -0500
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1L06lU-0000H5-DH
	for linux-scsi@vger.kernel.org; Tue, 11 Nov 2008 19:51:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello All:

Can anybody explain me how I can write to a sector which is listed in GList?

Here is what I want to do(why? Well, there may not be any practical use. I
am just exploring reamapping for academic purposes and as part of that I
want to be able to do this). 

If somebody issues a command to reassign a healthy sector, it will be marked
as bad and will be listed in GList even if it is not a defective sector. So,
if we send LBA of that sector to sg_write_long, it should be able to write
there. But, the issue here is that READ DEFECT DATA does not provide any
DEFECT LIST FORMAT to retrieve the address as LBA. We can get CHS address
though. I don't know how to convert CHS into LBA if the drive uses zone bit
recording. Given all this I am not quite able to figure out how I can use
the CHS address that I retrieved to write some stuff on that sector.

Any comments will be very useful. Please reply even if you think that there
is NO way to do this.

Thanks in advance...

- Mayuresh
-- 
View this message in context: http://www.nabble.com/Writing-to-a-sector-listed-in-GList-tp20453709p20453709.html
Sent from the linux-scsi mailing list archive at Nabble.com.

