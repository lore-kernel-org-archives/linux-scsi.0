From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] exposing sdev_target in sysfs
Date: 07 Sep 2004 10:11:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094566289.2069.16.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02D946@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45703 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268074AbUIGOLa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 10:11:30 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02D946@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-07 at 10:05, James.Smart@Emulex.Com wrote:
> Did you give any consideration to the fact that FC would like to see all FC nodes - not just those that are FCP targets ?  I assume we could augment this patch to deal with the transport allocating the target (or node) structures rather than it being a byproduct of lun attachment. I would also assume we'd still allow lun discovery to create targets as well for compatibility w/ LLDDs that don't call out to the transport to alloc targets.

Actually, no.  I'm playing purely with SPI here.  I assumed people with
FC stuff would be able to fix up the FC class after I'm done.

By nodes, I assume you mean initiator or target?  In which case, just
exposing them and attaching a processor device would seem to be
appropriate.

James


