From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: avoid harmless comparison warning
Date: Wed, 13 Jul 2016 23:15:14 -0400
Message-ID: <yq1lh14lxkt.fsf@sermon.lab.mkp.net>
References: <20160615204231.3784044-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20049 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbcGNDP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 23:15:27 -0400
In-Reply-To: <20160615204231.3784044-1-arnd@arndb.de> (Arnd Bergmann's message
	of "Wed, 15 Jun 2016 22:42:17 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Hannes Reinicke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> When building with -Wextra, we get a lot of warnings for the lpfc
Arnd> driver concerning expressions that are always true, starting with:

Arnd> drivers/scsi/lpfc/lpfc_attr.c: In function
Arnd> 'lpfc_enable_npiv_init': drivers/scsi/lpfc/lpfc_attr.c:2786:77:
Arnd> error: comparison of unsigned expression >= 0 is always true
Arnd> [-Werror=type-limits] drivers/scsi/lpfc/lpfc_attr.c: In function
Arnd> 'lpfc_enable_rrq_init': drivers/scsi/lpfc/lpfc_attr.c:2802:76:
Arnd> error: comparison of unsigned expression >= 0 is always true
Arnd> [-Werror=type-limits] drivers/scsi/lpfc/lpfc_attr.c: In function
Arnd> 'lpfc_suppress_link_up_init':
Arnd> drivers/scsi/lpfc/lpfc_attr.c:2812:2050: error: comparison of
Arnd> unsigned expression >= 0 is always true [-Werror=type-limits]
Arnd> drivers/scsi/lpfc/lpfc_attr.c: In function
Arnd> 'lpfc_log_verbose_init': drivers/scsi/lpfc/lpfc_attr.c:3064:1930:
Arnd> error: comparison of unsigned expression >= 0 is always true
Arnd> [-Werror=type-limits]

James, Dick: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
