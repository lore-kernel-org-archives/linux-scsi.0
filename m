From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/14] lpfc: Fix to remove IRQF_SHARED flag for MSI/MSI-X
 vectors.
Date: Tue, 21 Apr 2015 12:06:51 +0200
Message-ID: <5536213B.1030606@suse.de>
References: <55350590.RQUlxZyUzEkcVEaD%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbbDUKGw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:06:52 -0400
In-Reply-To: <55350590.RQUlxZyUzEkcVEaD%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org

On 04/20/2015 03:56 PM, James Smart wrote:
>=20
> Fix to remove IRQF_SHARED flag for MSI/MSI-X vectors.
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
