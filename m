From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: remove one useless stack variable
Date: Tue, 11 Oct 2016 18:02:45 -0400
Message-ID: <yq1shs2mtmi.fsf@sermon.lab.mkp.net>
References: <1476113133-24092-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476113133-24092-1-git-send-email-tom.leiming@gmail.com> (Ming
        Lei's message of "Mon, 10 Oct 2016 23:25:33 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ming" == Ming Lei <tom.leiming@gmail.com> writes:

Ming> The local variable of 'devname' in scsi_report_lun_scan() isn't
Ming> used any more, so remove it.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
