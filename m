From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [RFC PATCH 0/3] differentiate between I/O errors
Date: Fri, 10 Dec 2010 15:40:36 -0800
Message-ID: <20101210234036.GA4841@us.ibm.com>
References: <20101130225956.GA8882@redhat.com>
 <1291763802-8251-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu, sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net, rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

Mike Snitzer [snitzer@redhat.com] wrote:
> Refreshed Hannes' initial "scsi: Detailed I/O errors" patch against
> v2.6.37-rc5.  v2 introduces __scsi_error_from_host_byte to avoid
> the duplicate switch statement.  Also a few whitespace and comment
> changes.
> 
> Split DM mpath change out to separate v2 patch; failed discard is now
> retryable in the face of a non-target IO error.
> 
> Added improved block layer's I/O error message (based on the finer
> grained I/O error returns afforded by SCSI).
> 
> Comments/suggestions are welcome.

I did test the Hannes original patch with the latest Linus' git tree! I
used scsi_debug to simulate path failures as well as 'Media' failures
and it did work as expected. I will test your patches soon.

Thanks, Malahal.
