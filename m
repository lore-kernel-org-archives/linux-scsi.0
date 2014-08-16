From: Dan Aloni <dan@kernelim.com>
Subject: Re: [PATCH v3] scsi: ufs-msm: add UFS controller support for
 Qualcomm MSM chips
Date: Sat, 16 Aug 2014 20:33:25 +0300
Message-ID: <20140816173325.GA3961@gmail.com>
References: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Grant Likely <grant.likely@linaro.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 14, 2014 at 05:22:18PM +0300, Yaniv Gardi wrote:
> diff --git a/drivers/scsi/ufs/ufs-msm.h b/drivers/scsi/ufs/ufs-msm.h
> new file mode 100644
> index 0000000..6e93f1e
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-msm.h
> @@ -0,0 +1,158 @@
[...]
> +};
> +
> +static LIST_HEAD(phy_list);
> +

Just noticed this via a quick glance - Seems that this variable is not
referenced by any of the compilation units, what's the purpose of it?
And as a static global in a shared private, each of the including
compilation units gets a copy, which I am not sure was intended
anyway.

-- 
Dan Aloni
