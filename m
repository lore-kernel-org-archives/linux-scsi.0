From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] drivers/scsi/: Spelling fixes
Date: Mon, 17 Dec 2007 17:05:41 -0500
Message-ID: <4766F2B5.9010105@emulex.com>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com> <20071217215650.GQ8520@plap3.qlogic.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39153 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbXLQWFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 17:05:54 -0500
In-Reply-To: <20071217215650.GQ8520@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Andrew Vasquez <linux-driver@qlogic.com>, Brian King <brking@us.ibm.com>, Dave Jeffery <ipslinux@adaptec.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com


On Mon, 17 Dec 2007, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/NCR53C9x.h               |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_inline.h |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_osm.c    |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_pci.c    |    4 ++--
>  drivers/scsi/aic7xxx/aic7xxx_inline.h |    2 +-
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    2 +-
>  drivers/scsi/ipr.c                    |    2 +-
>  drivers/scsi/ips.c                    |    2 +-
>  drivers/scsi/iscsi_tcp.c              |    4 ++--
>  drivers/scsi/lpfc/lpfc.h              |    2 +-
>  drivers/scsi/lpfc/lpfc_mbox.c         |    2 +-
>  drivers/scsi/megaraid/megaraid_mbox.c |   10 +++++-----
>  drivers/scsi/psi240i.c                |    2 +-
>  drivers/scsi/qla2xxx/qla_gs.c         |    2 +-

For the lpfc bits:

Acked-by: James Smart <james.smart@emulex.com>

