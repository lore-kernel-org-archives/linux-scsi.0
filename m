From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v6 0/4] ata: Add APM X-Gene SoC SATA host controller support
Date: Sun, 22 Dec 2013 21:50:45 -0800
Message-ID: <CAPw-ZTn2n-HFa+1nExdEKZ6ETjODFjU4+ts5JxDhnn5dbG3xMw@mail.gmail.com>
References: <1386834940-30875-1-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1386834940-30875-1-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi All,

Any comment on v6 SATA host controller driver before I post v7 which
fix the clock DTS entry and etc due to the clock change in v5 of the
PHY driver?

-Loc

On Wed, Dec 11, 2013 at 11:55 PM, Loc Ho <lho@apm.com> wrote:
> This patch adds support for the APM X-Gene SoC SATA host controller. In
> order for the host controller to work, the corresponding PHY driver
> musts also be available.
>
> v6:
>  * Update binding documentation
>  * Change select PHY_XGENE_SATA to PHY_XGENE
>  * Add ULL to constants
>  * Change indentation and comments
>  * Clean up the probe functions a bit more
>  * Remove xgene_ahci_remove function
>  * Add the flush register to DTS
>  * Remove the interrupt-parent from DTS
>
