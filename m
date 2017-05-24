From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi: mark PM functions as __maybe_unused
Date: Tue, 23 May 2017 21:48:24 -0400
Message-ID: <yq1a863xbx3.fsf@oracle.com>
References: <20170518083243.2927102-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50766 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758528AbdEXBsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 21:48:41 -0400
In-Reply-To: <20170518083243.2927102-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 18 May 2017 10:32:18 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kevin Barnett <kevin.barnett@hpe.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Arnd,

> The newly added suspend/resume support causes harmless warnings when
> CONFIG_PM is disabled:

> We can avoid the warnings by removing the #ifdef around the handlers
> and instead marking them as __maybe_unused, which will let gcc drop
> the unused code silently.

Applied to 4.13/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
