From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] Update scsi_dh infrastructure
Date: Wed, 07 May 2008 17:03:29 +0200
Message-ID: <4821C4C1.2010602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762242AbYEGPDc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 11:03:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Chandra,

this patchset updates the scsi_dh infrastructure as laid out
in my previous mail. In particular it does

- update the scsi_dh infrastructure to implement a generic
  device table handling; the static device tables from the
  individual handlers are copied into a generic list.
  This allows us to do the checking in the main scsi_dh
  module instead of having to implement it for every handler.
  And we can then modify this list dynamically
- Implements a 'dh_state' attribute for the sdev, which
  allows for manipulating of the device handler itself.
  So we can now attach, detach, and activate any device
  handler manually.
- And finally I've updated my SPC-3 alua handler for the
  new infrastructure. Please include it in your patchset, too.

Patches are relative to your latest patchset.

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
