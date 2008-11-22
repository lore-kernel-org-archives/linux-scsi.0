From: Richard Scobie <richard@sauce.co.nz>
Subject: SES monitoring
Date: Sun, 23 Nov 2008 09:45:58 +1300
Message-ID: <49286F86.6080101@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:45394 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYKVUmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2008 15:42:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Are there any utilities around to monitor enclosure ses data?

I have found safte-monitor for SAF-TE enabled enclosures, but this does 
not apply to the enclosures in use here:

scsi 8:0:16:0: Enclosure         AIC      ED16-53C-01A2    114H PQ: 0 
ANSI: 5
scsi 8:0:16:0: Attached scsi generic sg18 type 13
ses 8:0:16:0: Attached Enclosure device

Regards,

Richard
