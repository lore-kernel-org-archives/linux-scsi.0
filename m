From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/14] lpfc: Fix crash in vport_delete.
Date: Tue, 21 Apr 2015 12:07:49 +0200
Message-ID: <55362175.4060700@suse.de>
References: <55350591.9Fc1EMkA5gMJGTDK%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbbDUKHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:07:51 -0400
In-Reply-To: <55350591.9Fc1EMkA5gMJGTDK%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org

On 04/20/2015 03:56 PM, James Smart wrote:
>=20
> Fix crash in vport_delete.
>=20
> We inadvertantly took the path to recreate the vport while in a
> driver teardown path
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
