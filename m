From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aacraid, 2.4.26, adaptec 2810sa
Date: Fri, 24 Sep 2004 16:02:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096066933.31620.67.camel@markh1.pdx.osdl.net>
References: <20040924221450.GA18494@thebackrow.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:14808 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S269046AbUIXXCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 19:02:47 -0400
In-Reply-To: <20040924221450.GA18494@thebackrow.net>
List-Id: linux-scsi@vger.kernel.org
To: Will Lowe <harpo@thebackrow.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Fri, 2004-09-24 at 15:14, Will Lowe wrote:
> I've got several Adaptec 2810SA SATA raid cards in use running Debian
> Woody with a 2.4.26 kernel using the aacraid driver.  The boxes are
> MySQL (4.1.1) servers with dual Xeon 2.8G cpus (hyperthreading is on)
> and the filesystem is reiserfs.
> 
> At irregular intervals we get this:
> 
> Sep 24 13:59:45 cd-grapherdb02b kernel: aacraid: Host adapter reset request. SCSI hang ?
> Sep 24 13:59:55 cd-grapherdb02b kernel: scsi: device set offline - command error recover failed: host 1 channel 0 id 0 lun 0
> Sep 24 13:59:55 cd-grapherdb02b kernel: SCSI disk error : host 1 channel 0 id 0 lun 0 return code = 6000000
> Sep 24 13:59:55 cd-grapherdb02b kernel:  I/O error: dev 08:11, sector 128
> Sep 24 13:59:55 cd-grapherdb02b kernel:  I/O error: dev 08:11, sector 532385968
> Sep 24 13:59:55 cd-grapherdb02b kernel: :11, sector 113398656
> Sep 24 13:59:55 cd-grapherdb02b kernel:  I/O error: dev 08:11, sector 113400000
> 

I don't see that the 2.4 aacraid driver has the timeout recovery code
like the 2.6 version does.  Mark Salyzyn at Adaptec may be able to point
you at an aacraid driver for 2.4 that does have that code in it though.

Mark.
-- 
Mark Haverkamp <markh@osdl.org>

