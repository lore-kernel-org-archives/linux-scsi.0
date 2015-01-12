From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/4] scsi: esp_scsi: adjust module reference for scsi
 host
Date: Mon, 12 Jan 2015 10:18:51 +0100
Message-ID: <54B3917B.7010406@suse.de>
References: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com> <1420984206-22341-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbbALJSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2015 04:18:53 -0500
In-Reply-To: <1420984206-22341-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

On 01/11/2015 02:50 PM, Akinobu Mita wrote:
> While accessing a scsi device on host adapter supported by sub driver=
 for
> the ESP chip (mac_esp, am53c974, sun_esp, jazz_esp, sun3x_esp), the m=
odule
> reference count is not incremented.  Because these drivers allocate s=
csi
> hosts with scsi_esp_template defined in ESP SCSI driver core module. =
 So
> these drivers always can be unloaded.
>=20
> This fixes it by passing correct module reference to newly introduced
> scsi_esp_host_alloc() so that .module field in struct Scsi_Host can b=
e
> adjusted.
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
> New patch from v3
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
