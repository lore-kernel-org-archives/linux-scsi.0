From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: Are QLA2000's doomed under 2.4?
Date: Mon, 9 Jun 2003 09:20:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609162047.GA24926@praka.local.home>
References: <20030609042014.GH4373@munchnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls01.socal.rr.com ([66.75.160.16]:24530 "EHLO
	orngca-mls01.socal.rr.com") by vger.kernel.org with ESMTP
	id S264537AbTFIRDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 13:03:07 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls01.socal.rr.com (8.11.4/8.11.3) with ESMTP id h59HDwM20886
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jun 2003 10:13:59 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h59GKnvl025092
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jun 2003 09:20:49 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h59GKmf1025091
	for linux-scsi@vger.kernel.org; Mon, 9 Jun 2003 09:20:48 -0700
Content-Disposition: inline
In-Reply-To: <20030609042014.GH4373@munchnet.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, 08 Jun 2003, Nathan Hunsperger wrote:

> I've been trying to get a QLA2000 (ISP2100) up and running under 2.4.20
> for a while now.  While I've been able to make it work, I can't make the
> system stable.
> 
> When I use the drivers in the kernel, the system locks up within 1
> minute of applying a heavy load.  When I use QLogic's driver, I get a
> very nice "this should not happen" error message and a frozen system
> within 15 minutes of heavy load.
> 

Which version of the QLogic driver are you trying to you trying to
use?  The latest beta 6.05.00b9 and the latest formal release
(6.04.00) contain no strings in the source which read as 'this should
not happen.'  The qlogicfc.c driver (in the kernel) contains the
following printk:

	printk("qlogicfc%d : no handle slots, this should not happen.\n",
		hostdata->host_id)

Is this the message you are referring to? 

IAC: Could you try the 6.05.00b9 which is available on the web:

	http://www.qlogic.com/support/os_detail.asp?productid=255&osid=26

QLogic doesn't formally support the EOLd ISP2100 chip, but the driver
has worked for a few others, and I'll try to help as best as I can.

Regards,
Andrew Vasquez
