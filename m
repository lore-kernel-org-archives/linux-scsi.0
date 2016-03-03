From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v5 01/15] scsi: ufs-qcom: add number of lanes per
 direction
Date: Thu, 3 Mar 2016 16:18:36 -0600
Message-ID: <20160303221836.GA3510@rob-hp-laptop>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456666367-11418-2-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 28, 2016 at 03:32:33PM +0200, Yaniv Gardi wrote:
> Different platform may have different number of lanes
> for the UFS link.
> Add parameter to device tree specifying how many lanes
> should be configured for the UFS link.
> 
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> 
> ---
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  3 ++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/scsi/ufs/ufs-qcom.c                        | 39 ++++++++++++----------
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 19 +++++++++++
>  drivers/scsi/ufs/ufshcd.c                          |  1 +
>  drivers/scsi/ufs/ufshcd.h                          |  2 ++
>  5 files changed, 47 insertions(+), 17 deletions(-)
