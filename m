From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/8] scsi_dh update
Date: Thu, 17 Jul 2008 09:37:29 +0200
Message-ID: <487EF6B9.20107@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:37739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760735AbYGQHhb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 03:37:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>

Hi James,

this is the (hopefully final) update to my scsi_dh patchset.
=46eatures are:

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

The NetApp device handler has been left out for now as it's still
under development.

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
