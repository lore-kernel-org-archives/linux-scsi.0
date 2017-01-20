From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Set elsiocb contexts to NULL after freeing it
Date: Fri, 20 Jan 2017 16:51:35 -0500
Message-ID: <yq1inp9iemw.fsf@oracle.com>
References: <20170110110554.13770-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170110110554.13770-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Tue, 10 Jan 2017 12:05:54 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Set the elsiocb contexts to NULL after freeing as others
Johannes> depend on it.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
