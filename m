From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 23/43] hpsa: clean up driver init
Date: Fri, 17 Apr 2015 15:19:43 +0200
Message-ID: <5531086F.7050102@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134848.30238.82165.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbbDQNTp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:19:45 -0400
In-Reply-To: <20150416134848.30238.82165.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:48 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>=20
> Improve initialization error handling in hpsa_init_one
> Clean up style and indent issues
> Rename functions for consistency
> Improve error messaging on allocations
> Fix return status from hpsa_put_ctlr_into_performant_mode
> Correct free order in hpsa_init_one using new function
>    hpsa_free_performant_mode
> Prevent inadvertent use of null pointers by nulling out the parent st=
ructures
>    and zeroing out associated size variables.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
