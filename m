From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi 1/7 RESEND] scsi_debug: define pr_fmt() for consistent logging
Date: Thu, 30 Jul 2015 13:21:29 -0400
Message-ID: <yq1lhdxo92e.fsf@sermon.lab.mkp.net>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	(Tomas Winkler's message of "Tue, 28 Jul 2015 16:54:20 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tomas" == Tomas Winkler <tomas.winkler@intel.com> writes:

Tomas> Use pr_fmt with both module name and __func__ Also drop few bare
Tomas> printk leftovers

Tomas> The log format should stay pretty much intact

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
