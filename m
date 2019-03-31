From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: scsi: ufs-cdns: Update Cadence UFS
 compatibility list
Date: Sun, 31 Mar 2019 01:42:48 -0500
Message-ID: <20190331025745.GA28612@bogus>
References: <20190327144405.5716-1-jank@cadence.com>
 <20190327144405.5716-2-jank@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190327144405.5716-2-jank@cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kotas <jank@cadence.com>
Cc: mark.rutland@arm.com, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 27, 2019 at 02:44:04PM +0000, Jan Kotas wrote:
> This patch adds a new compatible string description for
> CDNS UFS HCD + M31 16nm PHY.

The phy is not a separate block? 

> 
> Signed-off-by: Jan Kotas <jank@cadence.com>
> ---
>  Documentation/devicetree/bindings/ufs/cdns,ufshc.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> index a04a4989e..02347b017 100644
> --- a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> +++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> @@ -5,8 +5,9 @@ Each UFS controller instance should have its own node.
>  Please see the ufshcd-pltfrm.txt for a list of all available properties.
>  
>  Required properties:
> -- compatible	: Compatible list, contains the following controller:
> -			"cdns,ufshc"
> +- compatible	: Compatible list, contains one of the following controllers:
> +			"cdns,ufshc" - Generic CDNS HCI,
> +			"cdns,ufshc-m31-16nm" - CDNS UFS HC + M31 16nm PHY
>  		  complemented with the JEDEC version:
>  			"jedec,ufs-2.0"
>  
> -- 
> 2.15.0
> 
