From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 17/17] drivers/scsi/device_handler/scsi_dh_emc.c: suppress
 warning
Date: Tue, 14 Oct 2008 09:33:49 +0200
Message-ID: <48F44B5D.2060202@suse.de>
References: <200809222156.m8MLur8U032313@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:45044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbYJNHdv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 03:33:51 -0400
In-Reply-To: <200809222156.m8MLur8U032313@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, schwidefsky@de.ibm.com

Hi Andrew,

akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> s390:
>=20
> drivers/scsi/device_handler/scsi_dh_emc.c: In function 'parse_sp_info=
_reply':
> drivers/scsi/device_handler/scsi_dh_emc.c:179: warning: comparison is=
 always false due to limited range of data type
>=20
> because chars are unsigned, I assume.
>=20
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hannes Reinecke <hare@suse.de>
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
