From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Is the scsi-misc-2.5 BK tree corrupted?
Date: Thu, 12 Dec 2002 08:19:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212121419.gBCEJWp02105@localhost.localdomain>
References: <steve@kbuxd.necst.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA04817
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 06:19:34 -0800
In-Reply-To: Message from SL Baur <steve@kbuxd.necst.nec.co.jp>
   of "Thu, 12 Dec 2002 13:25:49 +0900." <15864.4045.584597.590434@sofia.bsd2.kbnes.nec.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: SL Baur <steve@kbuxd.necst.nec.co.jp>
Cc: linux-scsi@vger.kernel.org

steve@kbuxd.necst.nec.co.jp said:
> I am getting the following when attempting to pull from the current
> scsi-misc-2.5 BK tree. 

I have noticed BK do this periodically on other trees (most notably the linux 
ones).  It seems to be related to some type of backup program that bkbits 
runs.  I usually just wait a while and try again, which has worked so far.

James


