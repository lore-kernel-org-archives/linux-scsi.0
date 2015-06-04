From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Thu, 04 Jun 2015 16:42:10 +0200
Message-ID: <1433428930.15728.18.camel@x220>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
	 <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
	 <1433426833.15728.15.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1433426833.15728.15.camel@x220>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-06-04 at 16:07 +0200, Paul Bolle wrote:
> On Wed, 2015-06-03 at 12:37 +0300, Yaniv Gardi wrote:
> > +static int ufs_qcom_probe(struct platform_device *pdev)
> > +{
> > +	dev_set_drvdata(&pdev->dev, (void *)&ufs_hba_qcom_vops);
> 
> (Cast to void * should not be needed.)

Only if ufs_hba_qcom_vops wasn't a _const_ struct ufs_hba_variant_ops,
that is. Never mind.


Paul Bolle
