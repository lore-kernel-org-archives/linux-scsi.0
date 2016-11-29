From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] isci: avoid array subscript warning
Date: Tue, 29 Nov 2016 11:46:28 -0500
Message-ID: <yq1mvginsij.fsf@sermon.lab.mkp.net>
References: <20161118161418.755779-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20343 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932411AbcK2Qqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:46:45 -0500
In-Reply-To: <20161118161418.755779-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 18 Nov 2016 17:14:01 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Colin Ian King <colin.king@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> I'm getting a new warning with gcc-7: isci/remote_node_context.c:
Arnd> In function 'sci_remote_node_context_destruct':
Arnd> isci/remote_node_context.c:69:16: error: array subscript is above
Arnd> array bounds [-Werror=array-bounds]

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
