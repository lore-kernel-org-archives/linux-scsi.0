From: James.Smart@Emulex.Com
Subject: RE: [PATCH] exposing sdev_target in sysfs
Date: Tue, 7 Sep 2004 10:05:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02D946@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41095 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S268054AbUIGOFP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 10:05:15 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

James,

Did you give any consideration to the fact that FC would like to see all FC nodes - not just those that are FCP targets ?  I assume we could augment this patch to deal with the transport allocating the target (or node) structures rather than it being a byproduct of lun attachment. I would also assume we'd still allow lun discovery to create targets as well for compatibility w/ LLDDs that don't call out to the transport to alloc targets.

Ideas ?  I can help with such a patch, but would like to get your ideas (and the lists) on how such a thing should be done.

-- James S

 
