From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: two sym53c8xx.o modules
Date: Thu, 09 Oct 2003 02:43:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F84AF3C.9050408@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp14.eresmas.com ([62.81.235.114]:54958 "EHLO
	smtp14.eresmas.com") by vger.kernel.org with ESMTP id S261842AbTJIAoM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Oct 2003 20:44:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-kernel <linux-kernel@vger.kernel.org>

hi,

kernel 2.4 has two modules with *same name*:
/lib/modules/2.4.XX/kernel/drivers/scsi/sym53c8xx_2/sym53c8xx.o
/lib/modules/2.4.XX/kernel/drivers/scsi/sym53c8xx.o

"# modprobe sym53c8xx" tries to load sym53c8xx.o first and then sym53c8xx_2/sym53c8xx.o
bug or feature?

should be sym53c8xx_2/sym53c8xx.o renamed to sym53c8xx_2/sym53c8xx_2.o ?
                                                                  ^^
-thanks-

