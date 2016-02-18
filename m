From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v8 2/3] added UFS 2.0 capabilities
Date: Thu, 18 Feb 2016 08:38:37 -0600
Message-ID: <20160218143837.GD9654@rob-hp-laptop>
References: <cover.1455549221.git.jpinto@synopsys.com>
 <4e48beb48bc4c67c335de45218e2b49aa51dd4d9.1455549222.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4e48beb48bc4c67c335de45218e2b49aa51dd4d9.1455549222.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, arnd@arndb.de, mark.rutland@arm.com, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 15, 2016 at 03:25:12PM +0000, Joao Pinto wrote:
> Adding UFS 2.0 support to the UFS core driver.
> 
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> ---
> Changes v7->v8:
> - Added "jedec, ufs-2.0" to the ufschd-platform compatibility strings
> Changes v0->v7:
> - Nothing changed (just to keep up with patch set version).
> 
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 +--

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/scsi/ufs/ufshcd.c                          | 29 +++++++++++++++++++---
>  drivers/scsi/ufs/ufshci.h                          |  1 +
>  3 files changed, 28 insertions(+), 6 deletions(-)
> 
