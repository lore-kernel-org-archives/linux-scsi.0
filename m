From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 0/5] scsi: ufs: LU queue depth management
Date: Tue, 22 Jul 2014 09:05:33 -0700
Message-ID: <20140722160533.GA3345@infradead.org>
References: <1406039030-14246-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406039030-14246-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 22, 2014 at 05:23:45PM +0300, Dolev Raviv wrote:
> New version to fix multiple 'sparse' warnings.
> Add a driver wide fix to the endian 'sparse' warnings.
> Some UFS devices don't support a LUN queue depth same as the device queue
> depth. This requires reading the unit descriptor for extracting the LU's
> queue depth.

Can you please send just the sparse fixes against the tree at:

	http://git.infradead.org/users/hch/scsi-queue.git/shortlog/refs/heads/drivers-for-3.17

which already has the previous version merged?  
