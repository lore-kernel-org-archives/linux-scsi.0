From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 1/5] aic7xxx: deinline large or slow functions
Date: Sun, 27 Apr 2008 16:20:17 +0200
Message-ID: <200804271620.17885.vda.linux@googlemail.com>
References: <200804250432.16943.vda.linux@googlemail.com> <1209303692.3801.2.camel@localhost.localdomain> <200804271602.26563.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:11579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYD0OVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Apr 2008 10:21:16 -0400
Received: by fg-out-1718.google.com with SMTP id l27so4518603fgb.17
        for <linux-scsi@vger.kernel.org>; Sun, 27 Apr 2008 07:21:15 -0700 (PDT)
In-Reply-To: <200804271602.26563.vda.linux@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Sunday 27 April 2008 16:02, Denys Vlasenko wrote:
> On Sunday 27 April 2008 15:41, James Bottomley wrote:
> > > The first one (in this mail) was ACKed by you, so it's just a resend.
> > > 
> > > Following pathes were not ACKed and are modified.
> > > Please take a look.
> > 
> > The first three won't apply.  It looks like they're splits of this
> > existing one (at least quilt thinks they're all reverse applyable).
> 
> Most likely the first one was applied.
> Try applying patches 2 and 3.

I just tested it. Patch 1 is already in scsi-misc-2.6,
patches 2 and 3 apply cleanly:

# patch -p1 </tmp/aic_debloat_2.diff
patching file drivers/scsi/aic7xxx/aic79xx.h
patching file drivers/scsi/aic7xxx/aic79xx_core.c
patching file drivers/scsi/aic7xxx/aic79xx_inline.h
patching file drivers/scsi/aic7xxx/aic79xx_osm.c
patching file drivers/scsi/aic7xxx/aic79xx_osm.h
patching file drivers/scsi/aic7xxx/aic79xx_pci.c
patching file drivers/scsi/aic7xxx/aic7xxx.h
patching file drivers/scsi/aic7xxx/aic7xxx_core.c
patching file drivers/scsi/aic7xxx/aic7xxx_inline.h
patching file drivers/scsi/aic7xxx/aic7xxx_osm.c
patching file drivers/scsi/aic7xxx/aic7xxx_osm.h
patching file drivers/scsi/aic7xxx/aic7xxx_proc.c
# patch -p1 </tmp/aic_debloat_3.diff
patching file drivers/scsi/aic7xxx/aic79xx.h
patching file drivers/scsi/aic7xxx/aic79xx_core.c
patching file drivers/scsi/aic7xxx/aic79xx_osm.c
patching file drivers/scsi/aic7xxx/aic79xx_osm_pci.c
patching file drivers/scsi/aic7xxx/aic79xx_pci.c
patching file drivers/scsi/aic7xxx/aic79xx_proc.c
patching file drivers/scsi/aic7xxx/aic7xxx.h
patching file drivers/scsi/aic7xxx/aic7xxx_93cx6.c
patching file drivers/scsi/aic7xxx/aic7xxx_core.c
patching file drivers/scsi/aic7xxx/aic7xxx_osm.c
patching file drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
patching file drivers/scsi/aic7xxx/aic7xxx_pci.c
patching file drivers/scsi/aic7xxx/aic7xxx_proc.c

--
vda
