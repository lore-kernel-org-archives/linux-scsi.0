From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Sun, 23 Sep 2007 19:47:02 -0400
Message-ID: <46F6FAF6.5090604@garzik.org>
References: <20070923040437.GA30170@havoc.gtf.org> <46F6E1C2.20905@torque.net> <46F6FAC4.2020509@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46665 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXIWXrE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2007 19:47:04 -0400
In-Reply-To: <46F6FAC4.2020509@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Jeff Garzik wrote:
> Just for everybody's information, the Marvell SAS/SATA chip for which 
> I'm also writing a driver definitely supports all of that:  SMP, STP, 
> wire ports, SCSI target mode, even SATA target mode.

s/wire/wide/ of course

