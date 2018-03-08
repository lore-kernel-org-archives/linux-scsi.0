From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 01/10] dt-bindings: scsi: hisi_sas: add an property of
 signal attenuation
Date: Wed, 7 Mar 2018 20:34:56 -0600
Message-ID: <20180308023456.zhisinte6rjgdvid@rob-hp-laptop>
References: <1520425514-205565-1-git-send-email-john.garry@huawei.com>
 <1520425514-205565-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520425514-205565-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mark.rutland@arm.com, hare@suse.de, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 07, 2018 at 08:25:05PM +0800, John Garry wrote:
> From: Xiaofei Tan <tanxiaofei@huawei.com>
> 
> For some new boards with hip07 chipset we are required to
> set PHY config registers differently. The hw property which
> determines how to set these registers is in the PHY signal
> attenuation readings.
> 
> This patch add an devicetree property, "hisilicon,signal-attenuation",
> which is used to describe the signal attenuation of an board.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 7 +++++++
>  1 file changed, 7 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
