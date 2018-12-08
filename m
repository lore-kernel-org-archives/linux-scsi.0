From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedf: NULL check before some freeing functions is not needed.
Date: Fri, 07 Dec 2018 21:41:22 -0500
Message-ID: <yq1d0qcn3jh.fsf@oracle.com>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
        <1543760930052-271366275-12-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930052-271366275-12-diffsplit-thomas@m3y3r.de> (Thomas
        Meyer's message of "Sun, 02 Dec 2018 21:52:11 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Thomas,

> NULL check before some freeing functions is not needed.

Applied to 4.21/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
