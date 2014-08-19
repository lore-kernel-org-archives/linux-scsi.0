From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [RFC 09/10] scsi: sd: Avoid sending medium write commands if
 device is write protected
Date: Tue, 19 Aug 2014 10:55:57 -0700
Message-ID: <CAHdzE-8SsD0BFqiuGVpY-+mBG5ZdcCQ2iV3p7KzskTmFTcBoaA@mail.gmail.com>
References: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
	<1407760838-6406-10-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1407760838-6406-10-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 11, 2014 at 5:40 AM, Dolev Raviv <draviv@codeaurora.org> wrote:
> From: Sujit Reddy Thumma <sthumma@codeaurora.org>
>
> The SYNCHRONIZE_CACHE command is a medium write command and hence can
> fail when the device is write protected. Avoid sending such commands by
> making sure that write-cache-enable is disabled even though the device
> claim to support it.
>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

Looks good. Setting SWP is defined to flush caches; there is no other
reason I could imagine WP media would need a SYNCHRONIZE CACHE.

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
