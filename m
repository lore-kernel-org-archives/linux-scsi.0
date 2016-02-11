From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] qla2xxx: Fixes for target-pending
Date: Wed, 10 Feb 2016 23:11:35 -0800
Message-ID: <1455174695.27060.52.camel@haakon3.risingtidesystems.com>
References: <1455148754-17330-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1455148754-17330-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-02-10 at 18:59 -0500, Himanshu Madhani wrote:
> Hi Nic, 
> 
> Here are the patches that addresses review comments from Bart
> and Christoph. See email threads
> 
>  http://www.spinics.net/lists/target-devel/msg11418.html
>  http://www.spinics.net/lists/target-devel/msg11419.html
> 
> Please apply these patches to target-pending.
> 
> Thanks,
> Himanshu
> 
> Quinn Tran (2):
>   target/transport: add flag to indicate CPU Affinity is observed
>   qla2xxx: use TARGET_SCF_USE_CPUID flag to indiate CPU Affinity
> 
>  drivers/scsi/qla2xxx/qla_target.c      |    4 ++--
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    3 +++
>  drivers/target/target_core_transport.c |   12 +++++++++---
>  include/target/target_core_base.h      |    2 ++
>  4 files changed, 16 insertions(+), 5 deletions(-)
> 

Applied to target-pending/master.

Thanks Himanshu & Quinn!
