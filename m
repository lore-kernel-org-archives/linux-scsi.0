From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: [PATCH 0/3] Removing dead code (also drivers/scsi/arm/acornsci.c)
Date: Wed, 21 Jul 2010 15:57:35 +0200
Message-ID: <cover.1279719754.git.qy03fugy__40172.1842856661$1279720715$gmane$org@stud.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:61997 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719Ab0GUN5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 09:57:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Tejun Heo <tj@kernel.org>, Ji
Cc: vamos-dev@i4.informatik.uni-erlangen.de

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the drivers/scsi sourcetree for
config Items not defined in Kconfig and found  3 such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

        Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.

        I build the patches against a vanilla kernel in order to
try if the kernel compiles with this patches

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de/

Christian Dietrich (3):
  drivers/scsi: Remove dead CONFIG_WD33C93_PIO
  drivers/scsi/arcmsr: Remove dead CONFIG_SCSI_ARCMSR_RESET
  drivers/scsi: Removing dead CONFIG_AIC7XXX_PROC_STATS

 drivers/scsi/aic7xxx/aic7xxx_osm.c |   10 ----
 drivers/scsi/arcmsr/arcmsr_hba.c   |   80 ------------------------------------
 drivers/scsi/wd33c93.c             |   60 ---------------------------
 drivers/scsi/wd33c93.h             |    5 --
 4 files changed, 0 insertions(+), 155 deletions(-)

