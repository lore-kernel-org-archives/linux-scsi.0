From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: g_NCR5380: add HAS_IOPORT_MAP dependency
Date: Tue, 18 Oct 2016 21:10:02 -0400
Message-ID: <yq1d1ixf8k5.fsf@sermon.lab.mkp.net>
References: <20161018151827.2729976-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29150 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753216AbcJSBLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 21:11:32 -0400
In-Reply-To: <20161018151827.2729976-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 18 Oct 2016 17:18:06 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>, Finn Thain <fthain@telegraphics.com.au>, Hannes Reinecke <hare@suse.com>, Hannes Reinicke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The driver was changed to call ioport_map, which breaks platforms
Arnd> that cannot provide this function:

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
