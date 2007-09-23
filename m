From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Sun, 23 Sep 2007 19:46:12 -0400
Message-ID: <46F6FAC4.2020509@garzik.org>
References: <20070923040437.GA30170@havoc.gtf.org> <46F6E1C2.20905@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46652 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbXIWXqO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2007 19:46:14 -0400
In-Reply-To: <46F6E1C2.20905@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Douglas Gilbert wrote:
> Is the lack of SMP support a driver limitation or is it
> the silicon?
> 
> How about support for wide ports (i.e. when 2 or more HBA
> phys are attached to remote phys which have the same SAS
> addresses)?
> 
> Last question: can the chip run in SCSI target mode?


Just for everybody's information, the Marvell SAS/SATA chip for which 
I'm also writing a driver definitely supports all of that:  SMP, STP, 
wire ports, SCSI target mode, even SATA target mode.

	Jeff


