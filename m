From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: sym53c8xx=safe:y kernel boot option
Date: Mon, 30 Aug 2004 11:26:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408301826.i7UIQSWv009878@bach.leonora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:49131
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S268892AbUH3S0a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 14:26:30 -0400
Received: from bach.leonora.org (localhost.localdomain [127.0.0.1])
	by bach.leonora.org (8.12.11/8.12.11) with ESMTP id i7UIQSTx009881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 11:26:28 -0700
Received: from bach.leonora.org (vladimir@localhost)
	by bach.leonora.org (8.12.11/8.12.11/Submit) with ESMTP id i7UIQSWv009878
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 11:26:28 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

How do I verify that the kernel boot option

    sym53c8xx=safe:y 

was processed? There doesn't seem to be any acknowledgment in the kernel
log (other than being echoed as part of the kernel command line):

   kernel: Kernel command line: root=/dev/sda4 sym53c8xx=safe:y,buschk:0x2 debug:0x200 nmi_watchdog=1 panic=60

Thanks.

--- Vladimir

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
