From: Johann Hanne <jhml@gmx.net>
Subject: Is it possible to support a sector size 8192
Date: Fri, 22 Jul 2005 21:26:36 +0200
Message-ID: <200507222126.36623.jhml@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:37289 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262114AbVGVRTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 13:19:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi everybody,

i'm trying to access UDO/WORM mediums (which have a sector size of 8192) via a 
Plasmon UDO drive, but all I get is "unsupported sector size 8192" when I try 
to access it via /dev/sdX. drivers/scsi/sd.c suggests that the maximum sector 
size currently supported by Linux is 4096.

How difficult will it get to support 8192? Maybe we can pay somebody for doing 
it? (Kernel 2.4.21, RHEL 3.1).

Cheers, Johann
