From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/21] lpfc: Fix to handle PLOGI when already logged in
Date: Fri, 10 Apr 2015 08:07:16 +0200
Message-ID: <55276894.2040504@suse.de>
References: <1428095472.6933.32.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbbDJGHS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 02:07:18 -0400
In-Reply-To: <1428095472.6933.32.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, linux-scsi@vger.kernel.org

On 04/03/2015 11:11 PM, James Smart wrote:
> Fix to handle PLOGI when already logged in
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
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
