From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v3 0/2]]ata: Fix the dma state machine lockup for APM
 X-Gene SoC
Date: Fri, 20 Jun 2014 11:59:01 +0800
Message-ID: <CACVXFVPqhVSoxQQi4kS2+_Xmn9xAFcbRSpvoxU-yGJkxM7FUtw@mail.gmail.com>
References: <1403160538-31565-1-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1403160538-31565-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Suman,

On Thu, Jun 19, 2014 at 2:48 PM, Suman Tripathi <stripathi@apm.com> wrote:
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
> Suman Tripathi (2):
>   libahci: Implement the function ahci_restart_engine to restart the
>     port dma engine.
>   ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
>     command.
>
>  drivers/ata/ahci.h       |  2 ++
>  drivers/ata/ahci_xgene.c | 70 +++++++++++++++++++++++++++++++++++++++---------
>  drivers/ata/libahci.c    | 15 ++++++++++-
>  3 files changed, 73 insertions(+), 14 deletions(-)

These two patches does fix boot failure on our mustang board, thanks
Suman!

Reported-and-Tested-by: Ming Lei <ming.lei@canonical.com>

Thanks,
-- 
Ming Lei
