From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 2/2] arm64: Remove the clock and PHY reference from the APM X-Gene SoC AHCI SATA Host controller dts node.
Date: Sat, 9 Aug 2014 22:00:34 +0200
Message-ID: <201408092200.34651.arnd@arndb.de>
References: <1407514466-25312-1-git-send-email-stripathi@apm.com> <1407514466-25312-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1407514466-25312-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 08 August 2014, Suman Tripathi wrote:
> This patch removes all clocks and PHY references from the APM X-Gene
> SoC AHCI SATA host controller and PHY DTS nodes. The clock and PHY
> are no longer needed as they are handled by the firmware. By removing
> only the reference is not enough as any un-used clock entry will get
> disabled by the clock framework. This patch also updates the APM X-Gene
> SOC AHCI SATA Host controller clock and PHY bindings as optional
> properties.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  .../devicetree/bindings/ata/apm-xgene.txt          | 10 +--
>  arch/arm64/boot/dts/apm-storm.dtsi                 | 93 ----------------------
>  2 files changed, 5 insertions(+), 98 deletions(-)
> 

What is the upgrade path here? It sounds like this will still break new kernels
running on old firmware if you also upgrade the dtb file. You write in the
introductory email that this will work with old firmware as well, but I don't
understand how.

How about modifying the dtb at boot time by the firmware according to the
requirements of the firmware itself?

	Arnd
