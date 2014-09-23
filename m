From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH/RESEND V4 00/17] UFS: Power management support
Date: Tue, 23 Sep 2014 01:32:36 -0700
Message-ID: <20140923083236.GA28647@infradead.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com
List-Id: linux-scsi@vger.kernel.org

Just from a quick glance this is missing the wlun type fixup we recently
talked about, do you plan to send this as a separate series?

Also I've already merged the first patch, in case the new one differs
from the merged one in any way (doesn't seem so), please send an
incremental diff for it.
