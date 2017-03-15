From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi] scsi: ufshcd-platform: remove the useless cast in ERR_PTR/IS_ERR
Date: Wed, 15 Mar 2017 19:04:26 -0400
Message-ID: <yq1d1dign0l.fsf@oracle.com>
References: <20170314121936.1360-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170314121936.1360-1-tomas.winkler@intel.com> (Tomas Winkler's
        message of "Tue, 14 Mar 2017 14:19:36 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tomas Winkler <tomas.winkler@intel.com> writes:

> IS_ERR and ERR_PTR already forcefully cast their argument, hence there
> is no need for additional (complex) casting.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
