From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/14] lpfc: Fix for discovery failure in PT2PT when
 FLOGI's ELS ACC response gets aborted
Date: Mon, 14 Sep 2015 09:39:27 +0200
Message-ID: <55F679AF.8070906@suse.de>
References: <55e4bd92.KegerC79Wj93PQSl%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbbINHj3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:39:29 -0400
In-Reply-To: <55e4bd92.KegerC79Wj93PQSl%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> Fix for discovery failure in PT2PT when FLOGI's ELS ACC response gets=
 aborted
>=20
> Change login state machine to:
> - Restart FLOGI if prior is ABTS'd
> - Reject incoming FLOGIs if we have one pending
>=20
> The above ensures that we always finish FLOGI processing, regardless
> of who initated FLOGI, before processing PLOGI's.
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
