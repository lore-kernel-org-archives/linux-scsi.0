From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/1] Add 'this_id' scsi host attribute
Date: Wed, 18 Mar 2009 13:21:26 +0100
Message-ID: <49C0E746.5060502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZCRMYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 08:24:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

=46or calculating the TransportID for SPI we need to be able
to get the SCSI ID of the initiator (ie the SCSI HBA).
This information is already stored in the 'this_id' field,
but for some reason not exported via sysfs.
This patch adds a sysfs attribute 'this_id' to the SCSI
host.

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
