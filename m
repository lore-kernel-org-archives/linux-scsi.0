From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/9] lpfc: Fix scsi task management error message.
Date: Mon, 25 May 2015 17:20:00 +0200
Message-ID: <55633DA0.4020201@suse.de>
References: <555f4061.JF1uAXJ3MNmJF4W9%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbbEYPUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2015 11:20:01 -0400
In-Reply-To: <555f4061.JF1uAXJ3MNmJF4W9%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 05/22/2015 04:42 PM, James Smart wrote:
>=20
> Fix scsi task management error message.
>=20
> TMF's were getting error messages on FCP_RSP errors (underrun). Under=
runs
> aren't meaningful in the scenario. Change the error message to filter=
 out
> these response check errors, and don't unconditionally mark the cmd a=
s
> in error.
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
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
