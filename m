From: Jeff Garzik <jeff@garzik.org>
Subject: scsi-misc build breakage
Date: Wed, 26 Sep 2007 00:36:40 -0400
Message-ID: <46F9E1D8.2070106@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38874 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759502AbXIZEgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 00:36:42 -0400
Received: from cpe-069-134-071-233.nc.res.rr.com ([69.134.71.233] helo=core.yyz.us)
	by mail.dvmed.net with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1IaOdd-0004Iq-5Q
	for linux-scsi@vger.kernel.org; Wed, 26 Sep 2007 04:36:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

current scsi-misc on i386 says:

drivers/scsi/arcmsr/arcmsr_hba.c:129: error: =91arcmsr_pci_error_detect=
ed=92=20
undeclared here (not in a function)
drivers/scsi/arcmsr/arcmsr_hba.c:130: error: =91arcmsr_pci_slot_reset=92=
=20
undeclared here (not in a function)
make[2]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1
make[1]: *** [drivers/scsi/arcmsr] Error 2

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
