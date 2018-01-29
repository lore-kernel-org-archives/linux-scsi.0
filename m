From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] [SCSI] sym53c8xx_2: iterator underflow in sym_getsync()
Date: Mon, 29 Jan 2018 15:51:53 +0100
Message-ID: <mqda7wwiupi.fsf@linux-x5ow.site>
References: <20180125141340.GA7299@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbeA2Ovz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 09:51:55 -0500
In-Reply-To: <20180125141340.GA7299@mwanda> (Dan Carpenter's message of "Thu,
        25 Jan 2018 17:13:40 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
