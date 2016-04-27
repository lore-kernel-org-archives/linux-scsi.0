From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 05/10] aacraid: Disable MSI mode for series 6, 7, 8 cards
Date: Wed, 27 Apr 2016 11:16:27 +0200
Message-ID: <20160427091627.GC2820@c203.arch.suse.de>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063143.28402.72576.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbcD0JQa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 05:16:30 -0400
Content-Disposition: inline
In-Reply-To: <20160426063143.28402.72576.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com

On Mon, Apr 25, 2016 at 11:31:43PM -0700, Raghava Aditya Renukunta wrot=
e:
> As the firmware for series 6, 7, 8 cards does not support msi, remove=
 it
> in the driver
>=20
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@micr=
osemi.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
