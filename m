From: "C. Linus Hicks" <lhicks@nc.rr.com>
Subject: Vanilla 2.4.27 fails to compile on amd64
Date: 12 Sep 2004 13:11:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095009093.30166.632.camel@lh2.linush.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-lbl.southeast.rr.com ([24.25.9.101]:48866 "EHLO
	ms-smtp-02-eri0.southeast.rr.com") by vger.kernel.org with ESMTP
	id S268831AbUILRLg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2004 13:11:36 -0400
Received: from rdu26-80-175.nc.rr.com (rdu26-80-175.nc.rr.com [66.26.80.175])
	by ms-smtp-02-eri0.southeast.rr.com (8.12.10/8.12.7) with ESMTP id i8CHBYNr020865
	for <linux-scsi@vger.kernel.org>; Sun, 12 Sep 2004 13:11:34 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I couldn't figure out who supports drivers/scsi/aic7xxx from the
MAINTAINERS document, so here's to the list.

I'm trying to compile a vanilla 2.4.27 kernel on an AMD Opteron system
running Tao Linux x86_64 arch. I get this error:

cc1: warnings being treated as errors
aic79xx_osm_pci.c:278: warning: `ahd_linux_pci_reserve_mem_region'
defined but not used
make[3]: *** [aic79xx_osm_pci.o] Error 1

I have seen references to what seems to be the same problem mentioned on
this list June 2003 on 2.4.21 but it would seem either it wasn't fixed,
or the fix got lost.

Is there a patch for this problem, and can the fix be included
permanently in 2.4?

-- 
C. Linus Hicks <lhicks@nc.rr.com>

