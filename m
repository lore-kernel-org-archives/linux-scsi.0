From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] smartpqi: fix time handling
Date: Mon, 20 Feb 2017 22:03:18 -0500
Message-ID: <yq1lgt04555.fsf@oracle.com>
References: <20170217150417.2458237-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35055 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdBUDDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 22:03:38 -0500
In-Reply-To: <20170217150417.2458237-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 17 Feb 2017 16:03:52 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kevin Barnett <kevin.barnett@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, Scott Benesh <scott.benesh@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> When we have turned off RTC support, the smartpqi driver fails to
Arnd> build: ERROR: "rtc_time64_to_tm"
Arnd> [drivers/scsi/smartpqi/smartpqi.ko] undefined!

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
