From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/2] scsi: lpfc: avoid false-positive gcc-8 warning
Date: Fri, 25 Aug 2017 18:27:55 -0400
Message-ID: <yq17exr5llg.fsf@oracle.com>
References: <20170824231016.1843118-1-arnd@arndb.de>
        <20170824231016.1843118-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44062 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933777AbdHYW2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 18:28:10 -0400
In-Reply-To: <20170824231016.1843118-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 25 Aug 2017 01:10:00 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Arnd,

> This is an interesting regression with gcc-8, showing a harmless
> warning for correct code:

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
