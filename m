From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 2/4] arm64: Remove the clock and PHY reference from the APM X-Gene SoC AHCI SATA Host controller dts node.
Date: Tue, 29 Jul 2014 11:23:56 +0200
Message-ID: <4479076.DG8ITD3De2@wuerfel>
References: <1406616892-30273-1-git-send-email-stripathi@apm.com> <1406616892-30273-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1406616892-30273-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 29 July 2014 12:24:50 Suman Tripathi wrote:
> This patch removes all clocks and PHY references from the APM X-Gene
> SoC AHCI SATA host controller and PHY DTS nodes. The clock and PHY
> are no longer needed as they are handled by the firmware. By removing
> only the reference is not enough as any un-used clock entry will get
> disabled by the clock framework.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> 

This will break booting on older firmware versions I guess, and
it does not confirm to the binding that lists the phy and clock
properties as "required".

It doesn't sound like a good idea to apply it.

	Arnd
