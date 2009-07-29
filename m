From: Julia Lawall <julia@diku.dk>
Subject: question about drivers/scsi/aic7xxx/aic79xx_pci.c
Date: Wed, 29 Jul 2009 19:09:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907291907190.22045@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:52731 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbZG2RQC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 13:16:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, linux-scsi@vger.kernel.org

In the file drivers/scsi/aic7xxx/aic79xx_pci.c, the function 
ahd_aic790X_setup contains the code:

                ahd->features |= AHD_RTI|AHD_NEW_IOCELL_OPTS
                              |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY
                              |  AHD_BUSFREEREV_BUG;
                ahd->bugs |= AHD_LQOOVERRUN_BUG|AHD_EARLY_REQ_BUG;

Should AHD_BUSFREEREV_BUG be moved from ahd->features to ahd->bugs?

julia
