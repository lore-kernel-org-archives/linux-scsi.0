From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Sun, 06 Feb 2005 17:18:19 +0300
Message-ID: <4206272B.6030106@vlnb.net>
References: <0B1E13B586976742A7599D71A6AC733C12EAB3@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from asplinux.ru ([195.133.213.194]:42503 "EHLO relay.asplinux.ru")
	by vger.kernel.org with ESMTP id S261234AbVBFOQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2005 09:16:14 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EAB3@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com

Please, forgive me my ignorance, it looks like something was happened 
"behind the scene" (linux-scsi list), and I missed it. Is support for 
SCSI targets started to be added in Linux? I mean "SCSI targets" as the 
ability to export local devices on a SCSI bus. If so, please consider 
proposed SCSI target mid-level (SCST) living on 
http://scst.sourceforge.net. In the next few weeks we are going to clean 
it a bit and prepare the patch, so it could start being part of some 
testing tree, probably "-mm", although it is stable enough ever for 
Linus one.

BTW, are there any descriptions for current scsi_target support and in 
which direction it's moving?

Vlad

James.Smart@Emulex.Com wrote:
> Patch 3: 
>   This patch extends scsi_target support:
>   - Allows for driver-specific data to be allocated along with the
>     target structure and accessible via the starget->hostdata pointer.
>   - Adds scsi target alloc/configure/destory callbacks to the
>     scsi host template.
>   - Rearranges the calling sequences for scsi targets so that the
>     target and slave alloc/configure/destory callbacks are in
>     order (target before slave on alloc/configure).
> 
> -- James S

