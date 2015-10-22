From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7 6/8] scsi: ufs: make the UFS variant a platform device
Date: Thu, 22 Oct 2015 09:50:58 +0200
Message-ID: <4607478.zVSfzXyPzA@wuerfel>
References: <1441205138-12664-1-git-send-email-ygardi@codeaurora.org> <1441205138-12664-7-git-send-email-ygardi@codeaurora.org> <2dce3d8d918e124eb29afa7a59607bca.squirrel@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <2dce3d8d918e124eb29afa7a59607bca.squirrel@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: subhashj@codeaurora.org
Cc: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, gbroner@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thursday 22 October 2015 07:02:14 subhashj@codeaurora.org wrote:
> >
> >  Required properties:
> > -- compatible        : compatible list, contains "jedec,ufs-1.1"
> > +- compatible        : compatible list, contains "jedec,ufs-1.1" or
> > +		      "qcom,msm8994-ufshc" or "qcom,msm8996-ufshc"
> 
> Are we really using these "qcom,msm8994-ufshc" or "qcom,msm8996-ufshc"
> compatible string anywhere?

We should list them in either case, but it could be clarified as:

compatible	: must contain "jedec,ufs-1.1", may also list one or more
		  of the following:
			"qcom,msm8994-ufshc"
			"qcom,msm8996-ufshc"
			"qcom,ufshc"

	Arnd
