From: "Jan Peuker" <jan.peuker@janpeuker.de>
Subject: aacraid as module on 2.4.20
Date: Sun, 31 Oct 2004 00:19:06 +0200
Message-ID: <00e101c4bece$78d5e280$6501a8c0@lstzentrale.dom>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natnoddy.rzone.de ([81.169.145.166]:46271 "EHLO
	natnoddy.rzone.de") by vger.kernel.org with ESMTP id S261357AbUJ3WTD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Oct 2004 18:19:03 -0400
Received: from tronic5 (gw-ls6.spacenet.de [195.30.36.13])
	by post.webmailer.de (8.13.1/8.13.1) with SMTP id i9UMJ1SL010961
	for <linux-scsi@vger.kernel.org>; Sun, 31 Oct 2004 00:19:01 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Good evening everybody,

   at first, I want to say that I'm really sorry to post to this group 
without developing anything. But I am faciny really serious problems and in 
German it's weekend and after midnight - so I wont' get anybody else.

   I already found out what kind of problems I have - I only don't know what 
to do. I'm using Suse8.2 which has a unstable aacraid driver. I already read 
that I need some patches - but that's where my problem begins. I cant't 
install SuSE without these drivers, so I think I have to patch and compile 
the driver, then send it to the "modules disk". Alternatively I could 
compile the module and include it into the kernel after installing to a 
differend drive - and then do a chroot to the new drives. Is there anybody 
who may help me doing this, beginning from patching? I really don't know how 
to start. Maybe I forgot to mention that this is our main file server which 
has to running until tommorow morning.

Any help is greatly appreciated, thank you very much

jan 

