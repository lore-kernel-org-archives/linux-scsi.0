From: Rob Herring <robh@kernel.org>
Subject: Re: [v4 01/14] scsi: ufs-qcom: add number of lanes per direction
Date: Mon, 8 Feb 2016 11:53:17 -0600
Message-ID: <20160208175317.GA12559@rob-hp-laptop>
References: <1454582180-3823-1-git-send-email-ygardi@codeaurora.org>
 <1454582180-3823-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454582180-3823-2-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 04, 2016 at 12:36:07PM +0200, Yaniv Gardi wrote:
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
>  drivers/scsi/ufs/ufs-qcom.c                        | 39 ++++++++++++----------
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 19 +++++++++++
>  drivers/scsi/ufs/ufshcd.c                          |  1 +
>  drivers/scsi/ufs/ufshcd.h                          |  2 ++
>  5 files changed, 47 insertions(+), 17 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
