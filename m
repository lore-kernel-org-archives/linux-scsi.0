From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] advansys: Update to version 3.5 and remove compilation
 warning
Date: Fri, 24 Apr 2015 13:19:24 +0200
Message-ID: <553A26BC.5060609@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de> <1429874322-85488-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966425AbbDXLTZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:19:25 -0400
In-Reply-To: <1429874322-85488-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On 04/24/2015 01:18 PM, Hannes Reinecke wrote:
> The driver has now been converted to DMA-API, so we should
> increase the version number and remove the compilation
> warning.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
Gnaa. Slipped in during git-send.
Please ignore.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
