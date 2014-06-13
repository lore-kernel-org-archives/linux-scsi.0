From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 0/2]ata: Fix the dma state machine lockup for APM
 X-Gene SoC
Date: Fri, 13 Jun 2014 16:20:14 +0800
Message-ID: <CACVXFVMTfNtBe3FXNuo-UqzY5fx+CpGhSCBOspM9G6By8Oi4RA@mail.gmail.com>
References: <1402574362-24986-1-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1402574362-24986-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, ddutile@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

Hi Suman,

On Thu, Jun 12, 2014 at 7:59 PM, Suman Tripathi <stripathi@apm.com> wrote:
> Suman Tripathi (2):
>   libahci: Implement the function ahci_restart_engine to restart the
>     port dma engine.
>   ata: Fix the dma state machine lockup for the PIO mode commands.
>
>  drivers/ata/ahci.h       |  3 +++
>  drivers/ata/ahci_xgene.c | 17 +++--------------
>  drivers/ata/libahci.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 14 deletions(-)

Looks the patch doesn't fix the issue of booting hang on my
mustang board.

And the ata failure message still can be seen.


Thanks,
--
Ming Lei
