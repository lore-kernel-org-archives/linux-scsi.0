From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: 2.6.23-git2 advansys build error
Date: Fri, 12 Oct 2007 23:01:58 -0700
Message-ID: <20071012230158.9a5d4859.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:40459 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXJMGDr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Oct 2007 02:03:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: matthew@wil.cx

Yes, I know that there is a boatload of advansys patches in the works.

Anyway, today's git snapshot fails with:

drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'
drivers/scsi/advansys.c:17781: warning: pointer/integer type mismatch in conditional expression
drivers/scsi/advansys.c:17788: warning: unused variable 'pci_memory_address'
drivers/scsi/advansys.c:17781: warning: unused variable 'pdev'
  CC [M]  drivers/video/sysfillrect.o
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2

when CONFIG_PCI=n.

---
~Randy
