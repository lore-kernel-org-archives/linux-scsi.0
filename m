From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 8/24] advansys: Rewrite resource management
Date: Fri, 27 Jul 2007 10:39:06 -0400
Message-ID: <46AA038A.2010203@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437534057-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58239 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761231AbXG0OjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:39:08 -0400
In-Reply-To: <11855437534057-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Ancillary comments:

1) It is a common style to

	#define DRV_NAME "advansys"

at the top, and then use DRV_NAME in request_region() calls, 
request_irq() calls, struct eisa_driver, struct pci_driver, ...


2) A future cleanup might add __FUNCTION__ to ASC_PRINTx, eliminating a 
lot of manual reproduction of same


