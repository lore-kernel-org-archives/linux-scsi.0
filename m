From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aic94xx: Add missing error code assignment before test
Date: Thu, 25 Aug 2016 23:24:19 -0400
Message-ID: <yq1r39c9pr0.fsf@sermon.lab.mkp.net>
References: <1470742202-11100-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470742202-11100-1-git-send-email-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Tue, 9 Aug 2016 13:30:02 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christophe" == Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

Christophe> It is likely that checking the result of
Christophe> 'pci_write_config_dword' is expected here.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
