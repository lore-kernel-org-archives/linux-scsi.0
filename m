From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch.
Date: Thu, 23 Jul 2015 23:45:21 -0700
Message-ID: <1437720321.8929.26.camel@haakon3.risingtidesystems.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
	 <1437719934.8929.23.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36867 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbGXGpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2015 02:45:23 -0400
In-Reply-To: <1437719934.8929.23.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: jbottomley@parallels.com, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Thu, 2015-07-23 at 23:38 -0700, Nicholas A. Bellinger wrote:
> Hi Himanshu & Co,
> 
> (Adding target-devel CC')
> 
> On Wed, 2015-06-10 at 11:05 -0400, Himanshu Madhani wrote:
> > Hi James,

<SNIP>

> This series contains a number of qla2xxx target mode related bug-fixes
> that have not made it into scsi.git after 6 weeks on the list.  I don't
> see a good reason to wait another 6 weeks for v4.3-rc1 to get these into
> mainline.
> 
> That said, I'm going to merge patches #1-#7 via target-pending/master
> now and submit for v4.2-rc code.  Please re-submit the non bug-fix
> related changes in patches #8-#9 as for-4.3 code to JEJB -> scsi.git.
> 
> Here's the updated diff-stat for the bug-fix series.
> 
> Himanshu Madhani (2):
>   qla2xxx: Enable target mode for ISP27XX
>   qla2xxx: Remove msleep in qlt_send_term_exchange
> 
> Kanoj Sarcar (1):
>   qla2xxx: fix command initialization in target mode.
> 
> Quinn Tran (3):
>   qla2xxx: Add flush after updating ATIOQ consumer index.
>   qla2xxx: release request queue reservation.
>   qla2xxx: adjust debug flags
> 
> Saurav Kashyap (1):
>   qla2xxx: Fix hardware lock/unlock issue causing kernel panic.
> 
>  drivers/scsi/qla2xxx/qla_attr.c    |  2 +-
>  drivers/scsi/qla2xxx/qla_def.h     |  8 +++----
>  drivers/scsi/qla2xxx/qla_init.c    |  8 +++++--
>  drivers/scsi/qla2xxx/qla_mbx.c     |  7 +++---
>  drivers/scsi/qla2xxx/qla_os.c      |  1 +
>  drivers/scsi/qla2xxx/qla_sup.c     |  2 +-
>  drivers/scsi/qla2xxx/qla_target.c  | 49 +++++++++++++++++++-------------------
>  drivers/scsi/qla2xxx/qla_target.h  |  3 +++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  3 +--
>  9 files changed, 46 insertions(+), 37 deletions(-)
> 

Which reminds me, some of bug-fixes need proper CC' stable tags.

Can you give me your best guess as to which patches these should be, and
the approximate versions for the stable team to pick up..?

Thank you,

--nab

