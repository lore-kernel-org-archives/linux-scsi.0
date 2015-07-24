From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch.
Date: Fri, 24 Jul 2015 14:16:06 -0700
Message-ID: <1437772566.26220.18.camel@haakon3.risingtidesystems.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
	 <1437719934.8929.23.camel@haakon3.risingtidesystems.com>
	 <1437720321.8929.26.camel@haakon3.risingtidesystems.com>
	 <D1D7CBC8.A6A51%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <D1D7CBC8.A6A51%himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@lst.de" <hch@lst.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-07-24 at 18:32 +0000, Himanshu Madhani wrote:
> Hi Nic, 
> 
> 
> On 7/23/15, 11:45 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> >On Thu, 2015-07-23 at 23:38 -0700, Nicholas A. Bellinger wrote:
> >> Hi Himanshu & Co,
> >> 
> >> (Adding target-devel CC')
> >> 
> >> On Wed, 2015-06-10 at 11:05 -0400, Himanshu Madhani wrote:
> >> > Hi James,
> >
> ><SNIP>
> >
> >> This series contains a number of qla2xxx target mode related bug-fixes
> >> that have not made it into scsi.git after 6 weeks on the list.  I don't
> >> see a good reason to wait another 6 weeks for v4.3-rc1 to get these into
> >> mainline.
> >> 
> >> That said, I'm going to merge patches #1-#7 via target-pending/master
> >> now and submit for v4.2-rc code.  Please re-submit the non bug-fix
> >> related changes in patches #8-#9 as for-4.3 code to JEJB -> scsi.git.
> >> 
> >> Here's the updated diff-stat for the bug-fix series.
> >> 
> >> Himanshu Madhani (2):
> >>   qla2xxx: Enable target mode for ISP27XX
> >>   qla2xxx: Remove msleep in qlt_send_term_exchange
> >> 
> >> Kanoj Sarcar (1):
> >>   qla2xxx: fix command initialization in target mode.
> >> 
> >> Quinn Tran (3):
> >>   qla2xxx: Add flush after updating ATIOQ consumer index.
> >>   qla2xxx: release request queue reservation.
> >>   qla2xxx: adjust debug flags
> >> 
> >> Saurav Kashyap (1):
> >>   qla2xxx: Fix hardware lock/unlock issue causing kernel panic.
> >> 
> >>  drivers/scsi/qla2xxx/qla_attr.c    |  2 +-
> >>  drivers/scsi/qla2xxx/qla_def.h     |  8 +++----
> >>  drivers/scsi/qla2xxx/qla_init.c    |  8 +++++--
> >>  drivers/scsi/qla2xxx/qla_mbx.c     |  7 +++---
> >>  drivers/scsi/qla2xxx/qla_os.c      |  1 +
> >>  drivers/scsi/qla2xxx/qla_sup.c     |  2 +-
> >>  drivers/scsi/qla2xxx/qla_target.c  | 49
> >>+++++++++++++++++++-------------------
> >>  drivers/scsi/qla2xxx/qla_target.h  |  3 +++
> >>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  3 +--
> >>  9 files changed, 46 insertions(+), 37 deletions(-)
> >> 
> >
> >Which reminds me, some of bug-fixes need proper CC' stable tags.
> >
> >Can you give me your best guess as to which patches these should be, and
> >the approximate versions for the stable team to pick up..?
> 
> This patch http://marc.info/?l=linux-scsi&m=143395154920491&w=2 is already
> marked for stable and should be included in 3.18 and onwards. In addition
> following 
> patches should be picked up by stable team for 3.18 and onwards.
> 
> http://marc.info/?l=linux-scsi&m=143395156620504&w=2
> 
> http://marc.info/?l=linux-scsi&m=143395156320500&w=2
> 
> http://marc.info/?l=linux-scsi&m=143395154820489&w=2
> 

The stable v3.18+ tags for patch #1, #4, #6, and #7 have been added to
target-pending/master.

Since this series is a dependency for the larger patch-set from the Pure
folks, I'll go ahead and update those patches to a v3.18+ tag as well.

Thank you,

--nab
