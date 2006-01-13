From: "Zhikun Wang" <raidwang@gmail.com>
Subject: Re: RE: Calling scsi_done from queuecommand()
Date: Fri, 13 Jan 2006 09:44:39 +0800
Message-ID: <200601130944136568734@gmail.com>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F18160D@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.194]:21896 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964933AbWAMBmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 20:42:46 -0500
Received: by xproxy.gmail.com with SMTP id i30so381947wxd
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 17:42:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>



> On Wednesday, January 11, 2006 9:21 PM, Zhikun Wang wrote: 

> Mr. Moore:
> 	Can we call scsi_done() to complete the I/O from the 
> queuecommand() ? (e.g. to make 
> queuecommand synchronous).   I try this method in my LsiLogic 
> 22320 SCSI card driver 
> inMoore, Eric Redhat9, and i can correctly handle read command. But 
> Write command is stop when i 
> call scsi_done() in the queuecommand. I am very puzzled!   
> Thanks for any answers!
> 

> I see no problem with that as long as your waiting for the firmware

> to complete the command.
My problem is write command is completed for the firmware, but call scsi_done() is stopped!

