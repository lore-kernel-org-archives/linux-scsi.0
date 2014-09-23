From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 09/17] scsi: ufs: manually add well known logical units
Date: Tue, 23 Sep 2014 01:35:32 -0700
Message-ID: <20140923083532.GB28647@infradead.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
 <1411457499-8074-10-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411457499-8074-10-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

None of the REPORT LUNS language makes sense as we're not using it.

Can you respon the patch with a better description, and a little comment
in the code on why you're adding these wluns.

Also can I assume none of the later patches relies on their existance?
If you do you need to check the error return from scsi_add_device, if
not said comment should mention why it's fine to not actually find
any of these.

Also if you do use one of them from kernel space later it might make
more sense to use __scsi_add_device and store a pointer to the
scsi_device instead of looking it up later.
