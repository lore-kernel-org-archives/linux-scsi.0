From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 0/3] hpsa update
Date: Fri, 18 Dec 2015 10:12:45 +0100
Message-ID: <5673CE0D.7020600@suse.de>
References: <20151215155328.22855.56591.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbbLRJMs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:12:48 -0500
In-Reply-To: <20151215155328.22855.56591.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

On 12/15/2015 04:57 PM, Don Brace wrote:
> These patches are based on Linus's tree
>
> The changes are:
>   - correct missing changes from snprintf to scnprintf
>     in path_info_show by Rasmus Villemoes
>   - fix reported bus for SAS transport devices
>   - add in enclosure information
>
> Changes from initial upload
>   - added short patch description for patch
>     hpsa-add-enclosure-connection-box-bay-information
>   - kept hpsa-change-hba-controller-to-bus-0 the same to
>     minimize changes.
> ---
>
> Don Brace (3):
>        hpsa: fix path_info_show
>        hpsa: change SAS transport devices to bus 0.
>        hpsa: add box and bay information for enclosure devices
>
>
>   drivers/scsi/hpsa.c     |  118 ++++++++++++++++++++++++++++++++++++=
++++++-----
>   drivers/scsi/hpsa.h     |    2 -
>   drivers/scsi/hpsa_cmd.h |   13 +++++
>   3 files changed, 120 insertions(+), 13 deletions(-)
>
=46or the entire series:

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
