From: "Hibbard T. Smith, JR" <smitty@essnjay.com>
Subject: Kernel 2.6.5 with SymBios 53c1010 hangs at boot
Date: Sat, 29 May 2004 00:07:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <100301c44532$8210d8c0$6401a8c0@essnj2>
Reply-To: <smitty@essnjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from twighlight.propagation.net ([66.34.152.1]:26945 "EHLO
	twighlight.propagation.net") by vger.kernel.org with ESMTP
	id S261425AbUE2EHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 00:07:51 -0400
Received: from essnj2 (ct-naugatuck1d-85.wtrbct.adelphia.net [68.171.181.85])
	by twighlight.propagation.net (8.9.3p2/8.8.5) with ESMTP id XAA25232
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2004 23:07:00 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm trying to install Fedora core 2 which is using a 2.6.5 kernel.  My
Mother Board is an Asus CUV4X-DLS which has a dual channel SymBios 53c1010
on it.  These are my only SCSI controllers and all my discs are on them.
When booting from the cd, it gets to loading sym53c8xx and hangs.  The
driver on the cd is the sym53c8xx_2 driver.  This board and controllers work
fine in RedHat 9 (2.4.20 kernel).

-Smitty
Hibbard T. Smith, JR
smitty@essnjay.com

