From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH v3 2/2] ata: ahci_xgene: Add AHCI Support for 2nd HW
 version of APM X-Gene SoC AHCI SATA Host controller.
Date: Mon, 4 May 2015 10:26:25 +1000
Message-ID: <CAGRGNgWGk9jkg3Kui5BdFNhpCKOhD=SCW4apmzqMNHKfVbKMmw@mail.gmail.com>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com> <1430667220-23477-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1430667220-23477-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, devicetree <devicetree@vger.kernel.org>, "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

Hi Suman,

On Mon, May 4, 2015 at 1:33 AM, Suman Tripathi <stripathi@apm.com> wrote:
> This patch enables full AHCI feature support for APM X-Gene SoC SATA
> host controller. The following errata's are removed:
>
> 1. 2a0bdff6b95 ("ahci-xgene: fix the dma state machine lockup for the
>                  IDENTIFY DEVICE PIO mode command")
> 2. 09c32aaa368 ("ahci_xgene: Fix the dma state machine lockup for the
>                  ATA_CMD_SMART PIO mode command")
> 3. 1540035da71 ("ahci_xgene: Implement the xgene_ahci_poll_reg_val to
>                  support PMP")
> 4. a3a84bc7c88 ("ahci_xgene: Implement the workaround to support PMP
>                  enumeration and discovery")
> 5. 1102407bb71 ("ahci_xgene: Fix the DMA state machine lockup for the
>                  ATA_CMD_PACKET PIO mode command")
> 6. 72f79f9e35b ("ahci_xgene: Removing NCQ support from the APM X-Gene
>                 SoC AHCI SATA Host Controller driver")

Won't this mean that the 1st HW version won't work properly?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
