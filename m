From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aic79xx: fix warnings with CONFIG_PM disabled
Date: Tue, 29 Jan 2008 10:41:50 +0100
Message-ID: <479EF4DE.40402@suse.de>
References: <20080127000740N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:51187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYA2Jl4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 04:41:56 -0500
In-Reply-To: <20080127000740N.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

=46UJITA Tomonori wrote:
>   CC [M]  drivers/scsi/aic7xxx/aic79xx_osm_pci.o
> drivers/scsi/aic7xxx/aic79xx_osm_pci.c:101: warning: 'ahd_linux_pci_d=
ev_suspend' defined but not used
> drivers/scsi/aic7xxx/aic79xx_osm_pci.c:121: warning: 'ahd_linux_pci_d=
ev_resume' defined but not used
>=20
> This moves aic79xx_pci_driver struct, removes some forward
> declarations, and adds some ifdef CONFIG_PM.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
