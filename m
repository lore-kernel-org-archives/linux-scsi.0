From: raray@jam.rr.com
Subject: SCSI HBA in wrong order
Date: Fri, 9 Jul 2004 10:29:34 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407091027580.12759@rray1.jam.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01.texas.rr.com ([24.93.47.40]:32956 "EHLO
	ms-smtp-01-eri0.texas.rr.com") by vger.kernel.org with ESMTP
	id S264966AbUGIP3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 11:29:36 -0400
Received: from cs17020-79.jam.rr.com (cs17020-79.jam.rr.com [24.170.20.79])
	by ms-smtp-01-eri0.texas.rr.com (8.12.10/8.12.7) with ESMTP id i69FTYQ2012432
	for <linux-scsi@vger.kernel.org>; Fri, 9 Jul 2004 10:29:34 -0500 (CDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey all,

I have 3 Compaq Proliant ML370 servers with RedHat 9.0 and 2.4.23 kernel.
Each of these machines has an optical jukebox with 6 drives attached.
The 2 internal SCSI drives are attached to the HBA built into the system
board.
The jukebox is attached to a LSIU40HVD HBA.
Linux assigns the built in HBAs as scsi0 and scsi1 and assigns the
LSIU40HVD as scsi2 and scsi3.
I upgraded one server to Fedora Core 2 with 2.6.6 kernel.
Now Linux assigns the built in HBAs as scsi2 and scsi3 and assigns the
LSIU40HVD as scsi0 and scsi1.
This really screws things up. Anybody got any ideas how to fix this?

Thanks
Richard Ray


