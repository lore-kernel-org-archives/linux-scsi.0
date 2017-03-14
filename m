From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi] scsi: ufs: don't check unsigned type for a negative value
Date: Mon, 13 Mar 2017 23:02:08 -0400
Message-ID: <yq17f3sr26n.fsf@oracle.com>
References: <20170312102202.9889-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170312102202.9889-1-tomas.winkler@intel.com> (Tomas Winkler's
        message of "Sun, 12 Mar 2017 12:22:02 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tomas" == Tomas Winkler <tomas.winkler@intel.com> writes:

Tomas> Fix compilation warning drivers/scsi/ufs/ufshcd.c:7645:13:
Tomas> warning: comparison of unsigned expression < 0 is always false
Tomas> [-Wtype-limits] if ((value < UFS_PM_LVL_0) || (value >=
Tomas> UFS_PM_LVL_MAX))

Applied to 4.11/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
