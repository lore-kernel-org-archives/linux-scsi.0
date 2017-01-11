From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi 1/4] scsi: ufs: ufshcd_query_descriptor_retry should be static
Date: Tue, 10 Jan 2017 23:04:48 -0500
Message-ID: <yq1fukqs0m7.fsf@oracle.com>
References: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
        (Tomas Winkler's message of "Thu, 5 Jan 2017 10:45:09 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tomas" == Tomas Winkler <tomas.winkler@intel.com> writes:

Tomas> Fix the following compilation warning:
Tomas> drivers/scsi/ufs/ufshcd.c:2076:5: warning: no previous prototype
Tomas> for ‘ufshcd_query_descriptor_retry’ [-Wmissing-prototypes]

Tomas> Also do not export the function, it should not be used out of ufs
Tomas> context.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
