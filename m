From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 4/4] arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS
 entries
Date: Wed, 20 Nov 2013 22:03:02 +0400
Message-ID: <528CF956.3040104@cogentembedded.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com> <1384905197-3566-2-git-send-email-lho@apm.com> <1384905197-3566-3-git-send-email-lho@apm.com> <1384905197-3566-4-git-send-email-lho@apm.com> <1384905197-3566-5-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56887 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3KTSDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 13:03:20 -0500
Received: by mail-lb0-f174.google.com with SMTP id c11so3332838lbj.33
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 10:03:19 -0800 (PST)
In-Reply-To: <1384905197-3566-5-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hello.

On 20-11-2013 3:53, Loc Ho wrote:

> arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries

> This patch adds the DTS entries for the APM X-Gene SoC 6.0Gbps SATA PHY
> driver. The PHY for controller 0 and 1 are enabled by default.

> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   arch/arm64/boot/dts/apm-storm.dtsi |   28 ++++++++++++++++++++++++++++
>   1 files changed, 28 insertions(+), 0 deletions(-)

> diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
> index 359d7b6..1d1c8bc 100644
> --- a/arch/arm64/boot/dts/apm-storm.dtsi
> +++ b/arch/arm64/boot/dts/apm-storm.dtsi
> @@ -193,5 +193,33 @@
>   			reg = <0x0 0x17000014 0x0 0x100>;
>   			mask = <0x1>;
>   		};
> +
> +		sataphy0: sataphy@1f210000 {

    The nodes should better be named like "sata-phy@1f210000" to better comply 
with the "ethernet-phy" name we see in the ePAPR spec.

WBR, Sergei

