From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2] scsi: ufs-qcom: add number of lanes for Tx and Rx
 links
Date: Mon, 5 Mar 2018 16:02:00 -0600
Message-ID: <20180305220200.rah223rn4ndq7hd4@rob-hp-laptop>
References: <20180227055500.10416-1-cang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180227055500.10416-1-cang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Can Guo <cang@codeaurora.org>
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Amit Nischal <anischal@codeaurora.org>, Maya Erez <merez@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 27, 2018 at 01:46:17PM +0800, Can Guo wrote:
> From: Gilad Broner <gbroner@codeaurora.org>
> 
> Different platforms may have different number of lanes for the UFS Tx/Rx
> links. Add parameter to device tree specifying how many lanes should be
> configured for the UFS Tx/Rx links. And don't print err message for clocks
> that are optional, this leads to unnecessary confusion about failure.
> 
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
> 
> Changes since v1:
> 	- Change commit subject for better description.
> 	- Incorporated Rob's review comments to use lanes-tx and lanes-rx
> 	  to handle asymmetric Tx/Rx links.
> 
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 ++

Reviewed-by: Rob Herring <robh@kernel.org>

>  drivers/scsi/ufs/ufs-qcom.c                        | 65 +++++++++++++---------
>  drivers/scsi/ufs/ufshcd.c                          | 29 ++++++++++
>  drivers/scsi/ufs/ufshcd.h                          |  5 ++
>  4 files changed, 78 insertions(+), 25 deletions(-)
