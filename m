From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v6 0/3] CXL Flash Error Recovery and Superpipe
Date: Wed, 26 Aug 2015 18:57:03 -0700
Message-ID: <1440640623.31814.5.camel@haakon3.risingtidesystems.com>
References: <1439520443-56720-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <1440572202.8608.10.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51602 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbbH0B5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2015 21:57:06 -0400
In-Reply-To: <1440572202.8608.10.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com

On Tue, 2015-08-25 at 23:56 -0700, Nicholas A. Bellinger wrote:
> Hi Matthew & Co,
> 
> On Thu, 2015-08-13 at 21:47 -0500, Matthew R. Ochs wrote:
> > This patch set is intended for the 4.3 release and adds support for
> > error recovery and the superpipe features provided by the IBM CXL
> > Flash adapter. The superpipe function was originally presented in an
> > RFC patch set in late April. To aid with the review of the superpipe
> > portion of these enhancements, we have further split it across the
> > last two patches in this set. Please reference the changelog below
> > for details on what has been altered from previous versions of this
> > patchset.
> > 

<SNIP>

> > Matthew R. Ochs (3):
> >   cxlflash: Base error recovery support
> >   cxlflash: Superpipe support
> >   cxlflash: Virtual LUN support
> > 
> >  Documentation/ioctl/ioctl-number.txt |    1 +
> >  Documentation/powerpc/cxlflash.txt   |  318 ++++++
> >  drivers/scsi/cxlflash/Kconfig        |    2 +-
> >  drivers/scsi/cxlflash/Makefile       |    2 +-
> >  drivers/scsi/cxlflash/common.h       |   34 +-
> >  drivers/scsi/cxlflash/lunmgt.c       |  266 +++++
> >  drivers/scsi/cxlflash/main.c         |  221 +++-
> >  drivers/scsi/cxlflash/main.h         |    6 +-
> >  drivers/scsi/cxlflash/sislite.h      |   25 +-
> >  drivers/scsi/cxlflash/superpipe.c    | 2084 ++++++++++++++++++++++++++++++++++
> >  drivers/scsi/cxlflash/superpipe.h    |  147 +++
> >  drivers/scsi/cxlflash/vlun.c         | 1243 ++++++++++++++++++++
> >  drivers/scsi/cxlflash/vlun.h         |   86 ++
> >  include/uapi/scsi/Kbuild             |    1 +
> >  include/uapi/scsi/cxlflash_ioctl.h   |  174 +++
> >  15 files changed, 4584 insertions(+), 27 deletions(-)
> >  create mode 100644 Documentation/powerpc/cxlflash.txt
> >  create mode 100644 drivers/scsi/cxlflash/lunmgt.c
> >  mode change 100755 => 100644 drivers/scsi/cxlflash/sislite.h
> >  create mode 100644 drivers/scsi/cxlflash/superpipe.c
> >  create mode 100644 drivers/scsi/cxlflash/superpipe.h
> >  create mode 100644 drivers/scsi/cxlflash/vlun.c
> >  create mode 100644 drivers/scsi/cxlflash/vlun.h
> >  create mode 100644 include/uapi/scsi/cxlflash_ioctl.h
> > 
> 
> Thanks for including the full review history.
> 
> This series has been added to target-pending.git/for-next-merge atop
> current scsi.git/for-next code so it can be picked up by sfr for
> tomorrow's linux-next build.
> 
> James, please include this for v4.3-rc1 code.
> 

As this series + associated follow-up patches have been included into
scsi.git/for-next code, I'll drop these from target-pending.git.

Thanks folks,

--nab

