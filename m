From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 02/25] hpsa: remove unused hpsa_tag_discard_error_bits
Date: Fri, 30 Oct 2015 08:46:09 +0100
Message-ID: <56332041.8060500@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220441.5323.9715.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbbJ3HqL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 03:46:11 -0400
In-Reply-To: <20151028220441.5323.9715.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:04 PM, Don Brace wrote:
> This function is no longer used.
>=20
> Signed-off-by: Don Brace <don.brace@pmcs.com>
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
