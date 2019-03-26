From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla4xxx: fix a potential NULL pointer dereference
Date: Mon, 25 Mar 2019 22:25:26 -0400
Message-ID: <yq1d0mez815.fsf@oracle.com>
References: <20190314063100.12805-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314063100.12805-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Thu, 14 Mar 2019 01:30:59 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kangjie,

> In case iscsi_lookup_endpoint fails, the fix returns -EINVAL to avoid
> NULL pointer dereference.

Applied to 5.1/scsi-fixes, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
