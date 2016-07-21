From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] fnic: pci_dma_mapping_error() doesn't return an error code
Date: Wed, 20 Jul 2016 20:49:41 -0400
Message-ID: <yq1a8hberx6.fsf@sermon.lab.mkp.net>
References: <20160707082359.GD16742@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31970 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbcGUAyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 20:54:11 -0400
In-Reply-To: <20160707082359.GD16742@mwanda> (Dan Carpenter's message of "Thu,
	7 Jul 2016 11:23:59 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hiral Patel <hiralpat@cisco.com>, Maurizio Lombardi <mlombard@redhat.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> pci_dma_mapping_error() returns true on error and false on success.
Dan> Fixes: fd6ddfa4c1dd ('fnic: check pci_map_single() return value')

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
