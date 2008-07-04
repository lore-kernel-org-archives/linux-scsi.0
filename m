From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] scsi_dh patchset fixes
Date: Fri, 04 Jul 2008 15:45:42 +0200
Message-ID: <486E2986.6090209@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:42997 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbYGDNpn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2008 09:45:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

these patches just fix the suggestions made by you and Mike C.
- Check the return code from try_module_get()
- Use GFP_ATOMIC in the IO path

Patches apply on top of my previous patchset for the scsi_dh fixes.

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
