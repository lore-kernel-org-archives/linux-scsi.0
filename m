From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/9] blk: In elv_abort_queue skip requests with REQ_DONTPREP
 set
Date: Tue, 04 May 2010 12:40:53 +0200
Message-ID: <4BDFF9B5.9090100@suse.de>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com> <1272944228-30511-3-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0EDKk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 06:40:56 -0400
In-Reply-To: <1272944228-30511-3-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Mike Anderson wrote:
> Having REQ_DONTPREP set on a request can indicated that resources hav=
e been
> allocated for this request. In elv_abort_queue skip requests with
> REQ_DONTPREP set to avoid leaking resources.
>=20
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> Cc: Jens Axobe <jens.axboe@oracle.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
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
