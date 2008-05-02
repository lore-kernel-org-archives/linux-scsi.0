From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mptbase Code={Abort} (LSI SAS1068 PCI-X Fusion-MPT)
Date: Fri, 02 May 2008 16:26:21 +1200
Message-ID: <481A97ED.5050905@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:39863 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbYEBEWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 May 2008 00:22:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sebastian Wasilewski said:

There is still one thing I do not understand. I have made a test -- I
have connected three SATA hard drives directly to the controller using
cable supplied with the controller. The error still occurred. Then I
have changed the cable to the one supplied with other controller, as
well as hard drives (but model was still the same) and the error message
was still occurring.

I have changed controller (I have a few of them) but again, the problem
still existed.

------------------------------

If anyone else can replicate these errors using Sebastian's setup above 
I would interested in hearing.

I have a case open with LSI but apparently my HBA is a "prototype" board 
and this is complicating things. I have had no indication whether they 
can replicate this issue or not.

If anyone else from LSI is on this list and can wade through SR# 
2-209998499  I'd be interested in any suggestions. Time is running out 
for me and I will probably have to go with someone elses HBA.

Apologies for this mail not threading correctly, as I am not subscribed. 
The start of it can be found here:

http://marc.info/?l=linux-scsi&m=120805128416791&w=2

and carries on here:

http://marc.info/?l=linux-scsi&m=120869748422095&w=2

Regards,

Richard
