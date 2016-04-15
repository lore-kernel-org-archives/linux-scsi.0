From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v14 0/9] add support for DWC UFS Controller
Date: Fri, 15 Apr 2016 16:09:16 +0200
Message-ID: <5710F60C.5070800@suse.de>
References: <cover.1459448160.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbcDOOJT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 10:09:19 -0400
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>, linux-scsi@vger.kernel.org

On 04/13/2016 11:04 AM, Joao Pinto wrote:
> As requested, I am sending v14 to be included in the SCSI patchwork.
>=20
> The work consisted of:
> - Fixed typo in ufshcd-pltfrm.c
> - Tweak ufshcd.c for UFS 2.0 support
> - Implement ufshcd-dwc which contains all DWC HW specific code
> - Unipro attributes were added and new registers were added to the dr=
iver
> - Implement a tc-dwc-g210 containing G210 MPHY specific code
> - Implement a tc-dwc-g210 glue platform driver
> - Implement a tc-dwc-g210 glue pci driver
> - Documentation update
>=20
> Joao Pinto (9):
>   fixed typo in ufshcd-pltfrm
>   add UFS 2.0 to ufshcd-pltfrm bindings
>   added UFS 2.0 capabilities
>   added unipro attributes
>   added link status to ufshci
>   added support for DesignWare Controller
>   added support for Synopsys G210 Test Chip
>   add TC G210 platform driver
>   add TC G210 pci driver
>=20
=46or this series:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
