From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bfa: convert to strlcpy/strlcat
Date: Mon, 11 Dec 2017 21:32:24 -0500
Message-ID: <yq1374gsmkn.fsf@oracle.com>
References: <20171204144814.385412-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdLLChs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 21:37:48 -0500
In-Reply-To: <20171204144814.385412-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 4 Dec 2017 15:47:00 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Kees Cook <keescook@chromium.org>, Benjamin Poirier <bpoirier@suse.com>, Rasesh Mody <rasesh.mody@cavium.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Arnd,

> The bfa driver has a number of real issues with string termination
> that gcc-8 now points out:

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
