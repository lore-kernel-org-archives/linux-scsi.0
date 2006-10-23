From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 07/45] make drivers/scsi/aic7xxx/aic79xx_core.:ahd_set_tags()
 static
Date: Mon, 23 Oct 2006 14:00:09 +0200
Message-ID: <453CAEC9.4030606@suse.de>
References: <200610202148.k9KLm7iw004081@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45245 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932150AbWJWMAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 08:00:11 -0400
In-Reply-To: <200610202148.k9KLm7iw004081@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@stusta.de

Hi Andrew,

akpm@osdl.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
>=20
> ahd_set_tags() can now become static.
>=20
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
