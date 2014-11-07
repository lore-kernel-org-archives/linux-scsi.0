From: Andras Kovacs <akovacs@fixstars.com>
Subject: UNMAP command parameter list
Date: Fri, 7 Nov 2014 23:30:00 +0000 (UTC)
Message-ID: <loom.20141108T001847-741@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50947 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbaKGXkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 18:40:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1Xmt8O-0007lc-Nh
	for linux-scsi@vger.kernel.org; Sat, 08 Nov 2014 00:40:05 +0100
Received: from S0106602ad06f2965.gv.shawcable.net ([24.68.136.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 08 Nov 2014 00:40:04 +0100
Received: from akovacs by S0106602ad06f2965.gv.shawcable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 08 Nov 2014 00:40:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


  Hi all,

  I'm trying to see what parameters are passed to the UFS driver from the
SCSI midlayer when an UNMAP command is issued. In the UFS driver I can see
the 10 byte command itself in the unsigned char *cmnd field of the struct
scsi_cmnd, and it tells me that the parameter list length is 24 bytes (an 8
byte UNMAP Parameter List header followed by one 16 byte long UNMAP Block
Descriptor), but I'm having trouble finding where this UNMAP Parameter List
is. It doesn't seem to be in the cmnd[] byte array after the UNMAP command
itself.

  Can anyone tell me where I can find the UNMAP Parameter List which belongs
to a particular UNMAP command?

  Any and all info would be greatly appreciated.

  Andras


