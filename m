From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 01/45] drivers/scsi/aic7xxx/: possible cleanups
Date: Mon, 23 Oct 2006 13:59:12 +0200
Message-ID: <453CAE90.3070703@suse.de>
References: <200610202147.k9KLlwBt004063@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:43137 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932148AbWJWL7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 07:59:22 -0400
In-Reply-To: <200610202147.k9KLlwBt004063@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@stusta.de

Hi Andrew,

akpm@osdl.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
>=20
> - make needlessly global code static
>=20
> - #if 0 the following unused global functions:
>   - aic79xx_core.c: ahd_print_scb
>   - aic79xx_core.c: ahd_suspend
>   - aic79xx_core.c: ahd_resume
>   - aic79xx_core.c: ahd_dump_scbs
>   - aic79xx_osm.c: ahd_softc_comp
>=20
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
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
