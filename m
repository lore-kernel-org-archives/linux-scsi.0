From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic7xxx: Update type check in aicasm grammar
Date: Tue, 08 Apr 2008 14:27:13 +0200
Message-ID: <47FB64A1.7010000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYDHM1P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2008 08:27:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

with commit 7dc5ed933aec92870154d92695a908dd33958c26
the type_check() function for aicasm grammar actually
started to work; but of course it got called for all
the wrong reasons.
This patch updates the type_check() function in aicasm
to check the correct types only and makes aicasm run again.

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
