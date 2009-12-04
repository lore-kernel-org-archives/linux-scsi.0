From: Martin Scholl <ms@diskware.net>
Subject: LSI Logic 1068E and SATA port replicators (Sil3726)
Date: Fri, 04 Dec 2009 09:28:44 +0100
Message-ID: <4B18C83C.6060105@diskware.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail01.globalinfinity.de ([85.10.196.218]:57948 "EHLO
	mail.diskware.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754433AbZLDIwO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2009 03:52:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,


[disclaimer: what follows is probably a really stupid idea after all.]

We would like to use a LSI SAS 1068E board with Sil3726 SATA port
replicators. This obviously "fails" in that only 1 disk out of the 5
connected is actually visible.

I found, if SATA drivers are to support a port multiplier, they inhert
from sata_pmp_port_ops. Is an analog infrastructure available for the
sas-based HBAs to support SATA port multipliers? (BTW is such a setup
actually supported form a protocol point of view?)

I'm not a regular kernel hacker, so I cannot really help you in getting
quality sata mpm support (if possible after all) into the sas drivers.
What I can definitely offer is my time and will to test the driver
modifications you would send me.



Martin
