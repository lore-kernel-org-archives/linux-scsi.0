From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch.
Date: Fri, 24 Jul 2015 14:04:29 -0700
Message-ID: <1437771869.26220.14.camel@haakon3.risingtidesystems.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
	 <1437719934.8929.23.camel@haakon3.risingtidesystems.com>
	 <1437749478.2217.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38351 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbbGXVEb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2015 17:04:31 -0400
In-Reply-To: <1437749478.2217.13.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Fri, 2015-07-24 at 07:51 -0700, James Bottomley wrote:
> On Thu, 2015-07-23 at 23:38 -0700, Nicholas A. Bellinger wrote:
> > Hi Himanshu & Co,
> > 
> > (Adding target-devel CC')
> > 
> > On Wed, 2015-06-10 at 11:05 -0400, Himanshu Madhani wrote:
> > > Hi James,
> > > 
> > > Please apply the following patches to the scsi tree at your earliest
> > > convenience for inclusion in the next mainline merge window.
> > > 
> > > Thanks,
> > > Himanshu
> > > 
> > > Himanshu Madhani (3):
> > >   qla2xxx: Enable target mode for ISP27XX
> > >   qla2xxx: Remove msleep in qlt_send_term_exchange
> > >   qla2xxx: Enable Target counters in DebugFS.
> > > 
> > > Kanoj Sarcar (1):
> > >   qla2xxx: fix command initialization in target mode.
> > > 
> > > Quinn Tran (4):
> > >   qla2xxx: Add flush after updating ATIOQ consumer index.
> > >   qla2xxx: release request queue reservation.
> > >   qla2xxx: adjust debug flags
> > >   qla2xxx: Add FW resource count in DebugFS.
> > > 
> > > Saurav Kashyap (1):
> > >   qla2xxx: Fix hardware lock/unlock issue causing kernel panic.
> > > 
> > >  drivers/scsi/qla2xxx/qla_attr.c    |    2 +-
> > >  drivers/scsi/qla2xxx/qla_def.h     |   36 ++++++++++---
> > >  drivers/scsi/qla2xxx/qla_dfs.c     |  106 ++++++++++++++++++++++++++++++++++++
> > >  drivers/scsi/qla2xxx/qla_gbl.h     |    3 +-
> > >  drivers/scsi/qla2xxx/qla_init.c    |   20 ++++---
> > >  drivers/scsi/qla2xxx/qla_iocb.c    |    1 +
> > >  drivers/scsi/qla2xxx/qla_mbx.c     |   31 +++++------
> > >  drivers/scsi/qla2xxx/qla_os.c      |    1 +
> > >  drivers/scsi/qla2xxx/qla_sup.c     |    2 +-
> > >  drivers/scsi/qla2xxx/qla_target.c  |   60 ++++++++++++---------
> > >  drivers/scsi/qla2xxx/qla_target.h  |    3 +
> > >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    9 ++-
> > >  12 files changed, 208 insertions(+), 66 deletions(-)
> > > 
> > 
> > This series contains a number of qla2xxx target mode related bug-fixes
> > that have not made it into scsi.git after 6 weeks on the list.  I don't
> > see a good reason to wait another 6 weeks for v4.3-rc1 to get these into
> > mainline.
> 
> According to the request, they're not fixes, they're targetted for the
> merge window.  As such, they still require reviews ... but if you'd like
> to provide them, that would be great.
> 

Yes, I've reviewed + signed-off-by on the patches #1-#7 that are now in
target-pending/master.

> > That said, I'm going to merge patches #1-#7 via target-pending/master
> > now and submit for v4.2-rc code.  Please re-submit the non bug-fix
> > related changes in patches #8-#9 as for-4.3 code to JEJB -> scsi.git.
> 
> I don't, in principle object to this demand, because it looks for the
> description that the bug fixes should be split out, except that you
> should follow proper process and have one independent review.  Hannes or
> Christoph are probably the best placed.
> 

Each of the patches merged has two signed-off-by from different QLogic
folks, along with my own signed-off-by. 

