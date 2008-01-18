From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: Megaraid: Use of outb_p
Date: Fri, 18 Jan 2008 13:32:12 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501E5FD9C@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:54283 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbYARUc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jan 2008 15:32:26 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>

Alan, 

The in/outb_p in MegaRAID scsi driver is used for our old io mapped
megaraid controller.  There are still some customers are using those old
controller.  Please keep them.
 
Thanks.
 
Bo Yang  

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
Sent: Friday, January 18, 2008 7:36 AM
To: linux-scsi@vger.kernel.org; DL-MegaRAID Linux
Subject: Megaraid: Use of outb_p


I notice the MegaRAID driver uses outb_p. Can someone at LSI confirm
that the delays between each I/O are required, and if so how long they
must be.

I'm trying to sort out the use of in/outb_p and where it is unneccessary
or used for non ISA devices.

(Please cc me on the reply)
Alan

