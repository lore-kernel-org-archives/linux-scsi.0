From: Duc Dang <dhdang@apm.com>
Subject: Re: [PATCH] arm64: dts: apm: Fix compatible string for X-Gene 2 SATA
 controller DTS node
Date: Tue, 29 Mar 2016 12:11:21 -0700
Message-ID: <CADaLNDnU7UJOOFs9euPP035iJX5b1-p7jLoKB5f0Sn==Ec3sYA@mail.gmail.com>
References: <1459245294-22678-1-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1459245294-22678-1-git-send-email-rsahu@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Rameshwar Prasad Sahu <rsahu@apm.com>
Cc: Olof Johansson <olof@lixom.net>, tj@kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Devicetree List <devicetree@vger.kernel.org>, linux-arm <linux-arm-kernel@lists.infradead.org>, ddutile@redhat.com, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 29, 2016 at 2:54 AM, Rameshwar Prasad Sahu <rsahu@apm.com> wrote:
> Fix X-Gene SATA controller compatible string for Merlin board.
>
> Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
> Acked-by: Suman Tripathi <stripathi@apm.com>

I will queue this patch into xgene-next tree.

> ---
>  arch/arm64/boot/dts/apm/apm-shadowcat.dtsi |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi b/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
> index 5d87a3d..74d971e 100644
> --- a/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
> +++ b/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
> @@ -524,7 +524,7 @@
>                 };
>
>                 sata1: sata@1a000000 {
> -                       compatible = "apm,xgene-ahci";
> +                       compatible = "apm,xgene-ahci-v2";
>                         reg = <0x0 0x1a000000 0x0 0x1000>,
>                               <0x0 0x1f200000 0x0 0x1000>,
>                               <0x0 0x1f20d000 0x0 0x1000>,
> @@ -534,7 +534,7 @@
>                 };
>
>                 sata2: sata@1a200000 {
> -                       compatible = "apm,xgene-ahci";
> +                       compatible = "apm,xgene-ahci-v2";
>                         reg = <0x0 0x1a200000 0x0 0x1000>,
>                               <0x0 0x1f210000 0x0 0x1000>,
>                               <0x0 0x1f21d000 0x0 0x1000>,
> @@ -544,7 +544,7 @@
>                 };
>
>                 sata3: sata@1a400000 {
> -                       compatible = "apm,xgene-ahci";
> +                       compatible = "apm,xgene-ahci-v2";
>                         reg = <0x0 0x1a400000 0x0 0x1000>,
>                               <0x0 0x1f220000 0x0 0x1000>,
>                               <0x0 0x1f22d000 0x0 0x1000>,
> --
> 1.7.1
>

Regards,
Duc Dang.
