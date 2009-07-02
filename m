From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] Add BLIST_REPORTLUN2 to EMC SYMMETRIX
Date: Thu, 02 Jul 2009 15:35:09 +0000
Message-ID: <1246548909.4055.33.camel@mulgrave.site>
References: <200907012018.13695.jdelvare@suse.de>
	 <1246476812.3894.56.camel@mulgrave.site>
	 <20090701194224.GC20681@tpkurt2.suse.de>
	 <8F08A56613D77044BD153E2AC5DA0F84023B21A2@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45819 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbZGBPfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 11:35:11 -0400
In-Reply-To: <8F08A56613D77044BD153E2AC5DA0F84023B21A2@CORPUSMX40A.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: garloff@suse.de, jdelvare@suse.de, linux-scsi@vger.kernel.org, hare@suse.de

On Thu, 2009-07-02 at 10:38 -0400, berthiaume_wayne@emc.com wrote:
> There are still very old Symmetrix arrays out there that could be broken
> if we drop BLIST_SPARSELUN or BLIST_LARGELUN because they don't support
> REPORT_LUNS.

OK, as long as all the older arrays correctly return ILLEGAL REQUEST to
a REPORT LUNS command, we'll be fine.

James


