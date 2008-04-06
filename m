From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mptsas problem
Date: Mon, 07 Apr 2008 11:40:12 +1200
Message-ID: <47F95F5C.500@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:39212 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYDFXkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Apr 2008 19:40:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 > I recall seeing some of this problem on the list a few days ago, but 
I > can't remember what the subject was and was unable to find the thread.

You are perhaps thinking of this:

http://marc.info/?l=linux-scsi&m=120696978819085&w=2

but it seems to be a different issue.

 From the message you posted, it looks as though there may be a problem 
with sda.

Does smartctl -a -d ata /dev/sda show any obvious problems?

Regards,

Richard


