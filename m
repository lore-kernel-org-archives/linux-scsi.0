From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: request_buffer versus buffer in Scsi_Cmnd
Date: Fri, 27 Sep 2002 02:15:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209270915.CAA96467@classic.engr.sgi.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by zok.sgi.com (8.12.2/8.12.2/linux-outbound_gateway-1.2) with ESMTP id g8R8HHT1000542
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2002 01:17:17 -0700
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.9.3/8.9.3) with ESMTP id CAA37506
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2002 02:15:51 -0700 (PDT)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.9.3/8.9.3) id CAA96467
	for linux-scsi@vger.kernel.org; Fri, 27 Sep 2002 02:15:30 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I notice that the qlogicfc driver calls pci_map_sg with the request_buffer
field and pci_unmap_sg with the buffer field.

>From looking at the code in drivers/scsi/scsi*, it would appear that they
are mostly the same, and the fact that qlogicfc works would seem to confirm
that.  However, the fact that there are two different fields leads me
to ask what the difference is supposed to be.

thanks

jeremy
