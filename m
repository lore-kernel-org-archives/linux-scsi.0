From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] SCSI referrals support
Date: Thu, 20 Jan 2011 17:00:10 +0100
Message-ID: <4D385C0A.3000901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1ATPxQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2011 10:53:16 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 0EF3C890B6
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2011 16:53:16 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Agenda topic proposal:

SCSI referrals support has already been discussed at last year's LSF
conference. However, the solution proposed there would not support
failover and would require quite a lot of changes to multipathing.

To enable failover it might be an idea to handle the LUN directly in
multipathing. This would require eg:
- request splitting
- I/O alignment handling
- SCSI unit attention handling

I would be giving a short overview/presentation of the current
state of the art, the shortcomings on the original proposal,
and would like to invite a discussion on how to best support
SCSI referrals.

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
