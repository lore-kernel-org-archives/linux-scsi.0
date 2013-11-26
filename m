From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3 4/4] arm64: Add APM X-Gene SoC 15Gbps Multi-purpose
 PHY DTS entries
Date: Tue, 26 Nov 2013 12:40:33 +0400
Message-ID: <52945E81.3010708@cogentembedded.com>
References: <1385444818-29682-1-git-send-email-lho@apm.com> <1385444818-29682-2-git-send-email-lho@apm.com> <1385444818-29682-3-git-send-email-lho@apm.com> <1385444818-29682-4-git-send-email-lho@apm.com> <1385444818-29682-5-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49351 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3KZIkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2013 03:40:41 -0500
Received: by mail-lb0-f177.google.com with SMTP id w7so4089879lbi.36
        for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2013 00:40:39 -0800 (PST)
In-Reply-To: <1385444818-29682-5-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hello.

On 26-11-2013 9:46, Loc Ho wrote:

> arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries

    As I already said, there's no need to repeat the patch summary line (the 
mail subject) in the changelog verbatim.

> This patch adds the DTS entries for the APM X-Gene SoC 15Gbps Multi-purpose
> PHY driver. The PHY for SATA controller 0 and 1 are enabled by default.

> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   arch/arm64/boot/dts/apm-storm.dtsi |   31 +++++++++++++++++++++++++++++++
>   1 files changed, 31 insertions(+), 0 deletions(-)

> diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
> index 359d7b6..f74c26a 100644
> --- a/arch/arm64/boot/dts/apm-storm.dtsi
> +++ b/arch/arm64/boot/dts/apm-storm.dtsi
> @@ -193,5 +193,36 @@
>   			reg = <0x0 0x17000014 0x0 0x100>;
>   			mask = <0x1>;
>   		};
> +
> +		phy1: phy@1f210000 {

    Shouldn't the address part of the node name correspond to the first 
address specifier in the "reg" prop?

> +			compatible = "apm,xgene-phy";
> +			reg = <0x0 0x1f21a000 0x0 0x100>,
> +			      <0x0 0x1f21c000 0x0 0x100>;
> +			#phy-cells = <1>;
> +			status = "disabled";
> +			apm-tx-boost-gain = <0x2 0x2 0x2 0x2 0x2 0x2>;
> +			apm-tx-eye-tuning = <0xa 0xa 0xa 0xa 0xa 0xa>;

    The vendor name should be separated by comma in the vendor specific prop 
names.

> +		};

    Same comments about the other 2 PHY nodes.

WBR, Sergei

