From: Paul Wagland <paul@kungfoocoder.org>
Subject: Re: Megaraid driver updates and kernel 2.6.2
Date: Thu, 12 Feb 2004 12:32:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076585558.1875.4606.camel@paulw-desktop.allshare.nl>
References: <1076581679.1875.4533.camel@paulw-desktop.allshare.nl>
	 <20040212040437.F20727@cs.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out2.xs4all.nl ([194.109.24.12]:9738 "EHLO
	smtp-out2.xs4all.nl") by vger.kernel.org with ESMTP id S266334AbUBLLcv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 06:32:51 -0500
In-Reply-To: <20040212040437.F20727@cs.ualberta.ca>
List-Id: linux-scsi@vger.kernel.org
To: Steve Sutphen <steve@cs.ualberta.ca>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, atulm@lsil.com

On Thu, 2004-02-12 at 12:04, Steve Sutphen wrote:
> That is interesting.  I was having some problems with the SCSI 
> version of the MegaRAID (MegaRAID SCSI 320-2 model), and I had 
> similar lock up problems (under heavy I/O when a rebuild or 
> consitancy check was in progress) and I (think I) found that it 
> was a motherboard problem.  I was using a Tyan S2469 (dual AMD MP's) 
> and the solution was to change the Primary PCI bus speed to 
> 33MHz (using jumper J92).  Perhaps though there were driver
> problems that the slower bus speed did not tickle.

AFAI understand this :

iii.	New abort and reset handling. In these situations, driver allows more
	time for the firmware to complete outstanding requests instead of
	failing handlers right-away.

means that the fix is in the 2.00.4 driver, since the timeouts happen
(again AFAIU) when the firmware is too busy doing other stuff (i.e.
rebuilding) to handle all of the requests within the time out specified
by the driver/mid scsi layer.

cc.ing the linux-scsi list and Atul Mukker, since I have only just
started to do the background investigation into this card/driver and I
would hate to give out incorrect information :-). If I am wrong please
correct me! :-)

Cheers,
Paul



