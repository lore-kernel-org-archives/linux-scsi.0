From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mptbase Code={Abort}
Date: Mon, 14 Apr 2008 08:47:05 +1200
Message-ID: <48027149.7090502@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:38763 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYDMUqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 16:46:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 > Could you let me know when he replies, please? I would like know
 > whether it is something serious or can be ignored.

Certainly. I think this is certainly impacting performance badly, 
judging by the LED's on each drive - each time an error occurs, it can 
take up to 10 seconds for them toi settle back to a stable pattern of 
activity.

 > I have noticed that turning off NCQ significantly reduces amount of
 > the errors.

I have already tried this and found that the errors were slightly more 
frequent, but I had updated the HBA BIOS and firmware before I set the 
queues to 1, so I'm not sure which change had an effect.

Regards,

Richard

