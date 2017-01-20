From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Set elsiocb contexts to NULL after freeing it
Date: Fri, 20 Jan 2017 16:54:31 -0500
Message-ID: <yq1efzxiei0.fsf@oracle.com>
References: <20170110110554.13770-1-jthumshirn@suse.de>
        <yq1inp9iemw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1inp9iemw.fsf@oracle.com> (Martin K. Petersen's message of
        "Fri, 20 Jan 2017 16:51:35 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:
Johannes> Set the elsiocb contexts to NULL after freeing as others
Johannes> depend on it.

Martin> Applied to 4.11/scsi-queue.

Replied to the wrong mail, sorry. This fix is already upstream.

-- 
Martin K. Petersen	Oracle Linux Engineering
