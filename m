From: James.Smart@Emulex.Com
Subject: [PATCH 0/3] MidLayer updates
Date: Sat, 29 Jan 2005 09:02:58 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F324@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:11401 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262911AbVA2ODA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 09:03:00 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j0TE2wni007644
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2005 06:02:59 -0800 (PST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The following 3 patches extend the scsi midlayer. Changes were prompted
by recent discussions with Christoph as part of the Emulex driver thread.

Patch 1: 
  Updates the recent transport container patch for :
  - allow device driver-specific attributes to be added to class objects
  - exposes classdev to transport via setup function

Patch 2: 
  Adds io statistics (requests, completions, error count) as generic
  attributes for scsi devices.

Patch 3: 
  This patch extends scsi_target support:
  - Allows for driver-specific data to be allocated along with the
    target structure and accessible via the starget->hostdata pointer.
  - Adds scsi target alloc/configure/destory callbacks to the
    scsi host template.
  - Rearranges the calling sequences for scsi targets so that the
    target and slave alloc/configure/destory callbacks are in
    order (target before slave on alloc/configure).

Although bad form, as there's so much churn in this area, the following
dependencies exist:
- Patches were created against scsi-rc-fixes-2.6 bitkeeper tree.
- Patch 1 depends on Mike Christies patch 
  http://marc.theaimsgroup.com/?l=linux-scsi&m=110678937715985&w=2


-- James S
