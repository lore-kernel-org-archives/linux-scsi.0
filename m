From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/9] scsi_dh update
Date: Tue, 24 Jun 2008 12:03:11 +0200
Message-ID: <4860C65F.7080301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:49350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYFXKDN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 06:03:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

this is the consolidated patchset to update the SCSI device_handler
infrastructure. Features are:

- Move device-table matching into the device_handler infrastructure,
  so that individual drivers don't have to implement it themselves
- Adds a 'dh_state' sysfs attribute for manually attaching device
  handler to new or unknown disks; this allows to override the
  internal device tables
- Update the dm-multipath code to attach the device handler
  specified in the multipath configuration
- Add a cache to speed up lookup of several identical devices
- Update existing EMC, RDAC, and hp_sw device handler to use
  the new infrastructure
- Add new SPC-3 ALUA device handler
- Add new NetApp device handler

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
