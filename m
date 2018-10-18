From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH V15 1/2] scsi: ufs: set the device reference clock setting
Date: Thu, 18 Oct 2018 09:30:21 -0500
Message-ID: <20181018143021.GA18795@bogus>
References: <1539680382-31136-1-git-send-email-sayalil@codeaurora.org>
 <1539680382-31136-2-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539680382-31136-2-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sayali Lokhande <sayalil@codeaurora.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org, stummala@codeaurora.org, adrian.hunter@intel.com, jlbec@evilplan.org, linux-scsi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Mathieu Malaterre <malat@debian.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 16, 2018 at 02:29:41PM +0530, Sayali Lokhande wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> UFS host supplies the reference clock to UFS device and UFS device
> specification allows host to provide one of the 4 frequencies (19.2 MHz,
> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the
> device reference clock frequency setting in the device based on what
> frequency it is supplying to UFS device.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> Reviewed-by: Evan Green <evgreen@chromium.org>
> ---
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  6 ++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/scsi/ufs/ufs.h                             | 14 ++++
>  drivers/scsi/ufs/ufshcd.c                          | 83 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h                          |  2 +
>  4 files changed, 105 insertions(+)
