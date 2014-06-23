From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v1 3/3] arm64: Fix the APM X-Gene SoC SATA PHY clock DTS
 node csr-mask of the SATA Host Controller 1.
Date: Mon, 23 Jun 2014 14:56:50 +0400
Message-ID: <53A807F2.4000408@cogentembedded.com>
References: <1403518538-30697-1-git-send-email-stripathi@apm.com> <1403518538-30697-4-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1403518538-30697-4-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello.

On 06/23/2014 02:15 PM, Suman Tripathi wrote:

> This patch fixes the SATA PHY clock DTS node csr-mask of the SATA
> Host controller 1. This patch also fixes the status of the PHY
> clock node of SATA Host controller 1.

> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   arch/arm64/boot/dts/apm-storm.dtsi | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
> index f8c40a6..d14bcc4 100644
> --- a/arch/arm64/boot/dts/apm-storm.dtsi
> +++ b/arch/arm64/boot/dts/apm-storm.dtsi
> @@ -184,9 +184,9 @@
>   				reg = <0x0 0x1f21c000 0x0 0x1000>;
>   				reg-names = "csr-reg";
>   				clock-output-names = "sataphy1clk";
> -				status = "disabled";
> +				status = "ok";

    You don't need the specifically set "status to "ok" unless you're 
overriding the "status" prop; "ok" is assumed AFAIK.

WBR, Sergei

