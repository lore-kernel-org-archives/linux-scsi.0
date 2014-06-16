From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v2 0/2]ata: Fix the dma state machine lockup for APM
 X-Gene SoC
Date: Mon, 16 Jun 2014 23:59:21 +0800
Message-ID: <CACVXFVPQhwyMN0ynhXkmD+DipmPiSHH2YFN++iwE64o=nghCxA@mail.gmail.com>
References: <1402911336-31788-1-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1402911336-31788-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 16, 2014 at 5:35 PM, Suman Tripathi <stripathi@apm.com> wrote:
> Suman Tripathi (2):
>   libahci: Implement the function ahci_restart_engine to restart the
>     port dma engine.
>   ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
>     command.
>
>  drivers/ata/ahci.h       |  4 ++++
>  drivers/ata/ahci_xgene.c | 17 +++--------------
>  drivers/ata/libahci.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 51 insertions(+), 14 deletions(-)

V2 looks good and makes my mutang board bootable, thanks.

Reported-and-tested-by: Ming Lei <ming.lei@canonical.com>


Thanks,
--
Ming Lei
