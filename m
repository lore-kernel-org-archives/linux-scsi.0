From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Wed, 15 Feb 2017 15:48:52 +0900
Message-ID: <9e2ca83a-d355-64f5-5d82-031761134c57@wdc.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
 <20170215063454.GA15020@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5899 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdBOGtJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 01:49:09 -0500
In-Reply-To: <20170215063454.GA15020@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Ram Pai <linuxram@us.ibm.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>

Christoph,

On 2/15/17 15:34, Christoph Hellwig wrote:
> this looks reasonable, but we should ask Guilherme and Ram to confirm
> it fixes their originally reported issue.  I've added them to Cc.

Thank you.

Guilherme, Ram,

Please test ! The original fix breaks the zoned block device support
that was newly added to 4.10. So we need a fix for that and your issue
combined before Linus releases 4.10 stable this weekend.

Thanks.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
