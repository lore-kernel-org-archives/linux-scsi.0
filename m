From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support
Date: Thu, 08 Jun 2017 22:39:59 -0700
Message-ID: <1496986799.28997.24.camel@haakon3.risingtidesystems.com>
References: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
         <A01A1524-3760-4FFC-956F-2A82874B668D@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A01A1524-3760-4FFC-956F-2A82874B668D@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, "Tran, Quinn" <Quinn.Tran@cavium.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu & Quinn,

On Wed, 2017-06-07 at 05:02 +0000, Madhani, Himanshu wrote:
> > On Jun 3, 2017, at 3:10 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi Himanshu + Quinn,
> > 
> > Here is a small series to introduce proper percpu se_lun->lun_ref
> > counting for TMR, and add common code in target_submit_tmr() to
> > do tag lookup for unpacked_lun in order to drop the original
> > driver specific lookup within __qlt_24xx_handle_abts().
> > 
> > It's rather straight-forward, so review and test as a v4.13 item.
> > 
> > Thanks!
> > 
> > Nicholas Bellinger (3):
> >  target: Add support for TMR percpu reference counting
> >  target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support for ABORT_TASK
> >  qla2xxx: Convert QLA_TGT_ABTS to TARGET_SCF_LOOKUP_LUN_FROM_TAG
> > 
> > drivers/scsi/qla2xxx/qla_target.c      | 39 ++++++-----------------
> > drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  4 ++-
> > drivers/target/target_core_device.c    | 14 ++++++---
> > drivers/target/target_core_transport.c | 56 ++++++++++++++++++++++++++++------
> > include/target/target_core_base.h      |  3 +-
> > 5 files changed, 71 insertions(+), 45 deletions(-)
> > 
> > -- 
> > 1.9.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe target-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Series looks good. 
> 
> Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> 

Thanks for the review! 
