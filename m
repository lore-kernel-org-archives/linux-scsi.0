From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [PATCH v3] scsi: ufs-msm: add UFS controller support for Qualcomm MSM chips
Date: Sun, 24 Aug 2014 16:51:00 +0300
Message-ID: <000601cfbfa2$7482f3a0$5d88dae0$@codeaurora.org>
References: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org> <20140816173325.GA3961@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140816173325.GA3961@gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Dan Aloni' <dan@kernelim.com>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, 'Rob Herring' <robh+dt@kernel.org>, 'Pawel Moll' <pawel.moll@arm.com>, 'Mark Rutland' <mark.rutland@arm.com>, 'Ian Campbell' <ijc+devicetree@hellion.org.uk>, 'Kumar Gala' <galak@codeaurora.org>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, 'Grant Likely' <grant.likely@linaro.org>, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, 'Sahitya Tummala' <stummala@codeaurora.org>, "'open list:OPEN FIRMWARE AND...'" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Dan,

Your quick glance did spotted a good catch. This variable if un-necessary,
A new version will be uploaded soon

Thanks,
Yaniv


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dan Aloni
Sent: Saturday, August 16, 2014 8:33 PM
To: Yaniv Gardi
Cc: James.Bottomley@HansenPartnership.com; hch@infradead.org;
linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com;
linux-scsi-owner@vger.kernel.org; subhashj@codeaurora.org;
noag@codeaurora.org; draviv@codeaurora.org; Rob Herring; Pawel Moll; Mark
Rutland; Ian Campbell; Kumar Gala; Vinayak Holikatti; James E.J. Bottomley;
Grant Likely; Sujit Reddy Thumma; Sahitya Tummala; open list:OPEN FIRMWARE
AND...
Subject: Re: [PATCH v3] scsi: ufs-msm: add UFS controller support for
Qualcomm MSM chips

On Thu, Aug 14, 2014 at 05:22:18PM +0300, Yaniv Gardi wrote:
> diff --git a/drivers/scsi/ufs/ufs-msm.h b/drivers/scsi/ufs/ufs-msm.h 
> new file mode 100644 index 0000000..6e93f1e
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
compilation units gets a copy, which I am not sure was intended anyway.

--
Dan Aloni
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
