From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] Evaluate TPGS setting for ALUA device handler
Date: Thu, 19 Mar 2009 09:05:52 +0100
Message-ID: <49C1FCE0.3040808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZCSIFz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 04:05:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The ALUA device handler should only be attached if the 'TPGS' setting
in the inquiry structure indicates so. So we should be evaluating the
'tpgs' setting when trying to attach the ALUA device handler.
This way we can get rid of the explicit device table in scsi_dh_alua
and will support any ALUA capable device out-of-the-box.

This is a repost of the patchset send yesterday, including
the suggestions from James B. to just pull the tpgs setting
off the inquiry data instead of adding a new field in the
scsi_device structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
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
