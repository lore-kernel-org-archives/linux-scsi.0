From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 3/3] add support for DWC UFS Host Controller
Date: Thu, 03 Mar 2016 15:12:20 +0100
Message-ID: <12939431.liKZREJb7L@wuerfel>
References: <cover.1455549221.git.jpinto@synopsys.com> <10452689.JXS9XIs74z@wuerfel> <56D841A7.7050008@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56D841A7.7050008@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com, robh@kernel.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 03 March 2016 13:52:39 Joao Pinto wrote:
> 
> config SCSI_UFS_DWC
>         bool
> 
> config SCSI_UFS_DWC_TC_PLATFORM
>         tristate "DesignWare platform support using a G210 Test Chip"
>         depends on SCSI_UFSHCD_PLATFORM
>         select SCSI_UFS_DWC
>         ---help---
>           Synopsys Test Chip is a PHY for prototyping purposes.
> 
>           If unsure, say N."
> 
> config SCSI_UFS_DWC_TC_PCI
>         tristate "DesignWare pci support using a G210 Test Chip"
>         depends on SCSI_UFSHCD_PCI
>         select SCSI_UFS_DWC
>         ---help---
>           Synopsys Test Chip is a PHY for prototyping purposes.
> 
>           If unsure, say N."
> 
> I would keep SCSI_UFS_DWC to avoid building DWC specific source everytime.
> 
> Agree?
> 

Yes, looks good to me.

	Arnd
