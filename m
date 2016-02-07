From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] qla2xxx: Patches for target-pending branch
Date: Sat, 06 Feb 2016 20:31:10 -0800
Message-ID: <1454819470.10001.8.camel@haakon3.risingtidesystems.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu & Co,

On Thu, 2016-02-04 at 11:45 -0500, Himanshu Madhani wrote:
> Hi Nic, 
> 
> Please apply following patches to target-pending branch at your earliest
> convenience.
> 
> Thanks,
> Himanshu
> 
> Quinn Tran (3):
>   qla2xxx: Fix stale pointer access.
>   qla2xxx: Add DebugFS node for target sess list.
>   qla2xxx: Add DebugFS node to show irq vector's cpuid
> 
> Swapnil Nagle (1):
>   qla2xxx: Use ATIO type to send correct tmr response
> 
>  drivers/scsi/qla2xxx/qla_def.h    |    3 +
>  drivers/scsi/qla2xxx/qla_dfs.c    |  104 +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_init.c   |   10 ++--
>  drivers/scsi/qla2xxx/qla_isr.c    |   20 ++++++-
>  drivers/scsi/qla2xxx/qla_mid.c    |    4 +-
>  drivers/scsi/qla2xxx/qla_os.c     |    6 ++
>  drivers/scsi/qla2xxx/qla_target.c |   58 +++++++++++++-------
>  drivers/scsi/qla2xxx/qla_tmpl.c   |   16 ++++++
>  8 files changed, 192 insertions(+), 29 deletions(-)
> 

Applied #1 + #2 to target-pending/master.

Commenting on the others inline.
