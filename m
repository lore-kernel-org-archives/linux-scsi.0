From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 9/8] Rework SCSI target allocation
Date: Tue, 18 Mar 2008 14:38:32 +0100
Message-ID: <47DFC5D8.5010700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYCRNid (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:38:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

forgot to add: these patches are relative to your scsi-post-merge
branch. It needs the updates / fixes from there.

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
