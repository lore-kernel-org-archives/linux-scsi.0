From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Prototype SATA -> SCSI error mapper
Date: Wed, 18 Aug 2004 01:56:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4122EF75.7000109@pobox.com>
References: <20040816141243.GA3898@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:65462 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268651AbUHRF4T
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2004 01:56:19 -0400
In-Reply-To: <20040816141243.GA3898@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: linux-scsi@vger.kernel.org

I went ahead and applied this patch to my libata 2.4 and 2.6 queues, to 
be sent upstream as soon as Marcelo/Linus take more stuff.

James mentioned some of the sense code translations may need work, but I 
filed this under "it's better than what's there now" category.

Update patches (from anyone) are welcome, scrutinizing and correcting 
any silly sense code translations.  For all I know, some SCSI expert may 
realize that an ATA UDMA CRC error is getting translated to the 'duck on 
fire' additional sense code.

	Jeff



