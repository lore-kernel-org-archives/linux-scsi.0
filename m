From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/2] libata: Pass correct DMA device to scsi host
Date: Thu, 22 Mar 2012 13:22:58 -0400
Message-ID: <4F6B5FF2.7050500@garzik.org>
References: <1332433926-9132-1-git-send-email-mlin@ss.pku.edu.cn> <1332433926-9132-3-git-send-email-mlin@ss.pku.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55246 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2CVRXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 13:23:02 -0400
In-Reply-To: <1332433926-9132-3-git-send-email-mlin@ss.pku.edu.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <mlin@ss.pku.edu.cn>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?UTF-8?B?77+9?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On 03/22/2012 12:32 PM, Lin Ming wrote:
> From: Lin Ming<ming.m.lin@intel.com>
>
> Use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
> correct DMA device(ATA host).
>
> Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2
>
> Reported-and-tested-by: J=EF=BF=BDrg Sommer<joerg@alea.gnuu.de>
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
