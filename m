From: James.Smart@Emulex.Com
Subject: RE: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Sun, 6 Feb 2005 12:28:17 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EB2A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:29607 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261228AbVBFR2X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 12:28:23 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vst@vlnb.net, linux-scsi@vger.kernel.org

No - there was no discussion of adding scsi targets to linux (per your
definition or otherwise).

Since the Emulex driver tracks things by target (actually FC remote port)
rather than luns, having the ability to have driver data space in the
lun didn't help much. Yes, the driver data space could be in the
transport-specific FC remote port, but I thought a more generic solution
would have been prefered - thus the patch request.

At this point, it appears that consensus is against the need for this,
especially as it can be handled within the only area needed today - that of
the FC transport.

-- james s


> -----Original Message-----
> From: Vladislav Bolkhovitin [mailto:vst@vlnb.net]
> Sent: Sunday, February 06, 2005 9:18 AM
> To: linux-scsi@vger.kernel.org
> Cc: Smart, James
> Subject: Re: [PATCH 3/3] MidLayer updates - extending scsi_target
> support
> 
> 
> Please, forgive me my ignorance, it looks like something was happened 
> "behind the scene" (linux-scsi list), and I missed it. Is support for 
> SCSI targets started to be added in Linux? I mean "SCSI 
> targets" as the 
> ability to export local devices on a SCSI bus. If so, please consider 
> proposed SCSI target mid-level (SCST) living on 
> http://scst.sourceforge.net. In the next few weeks we are 
> going to clean 
> it a bit and prepare the patch, so it could start being part of some 
> testing tree, probably "-mm", although it is stable enough ever for 
> Linus one.
> 
> BTW, are there any descriptions for current scsi_target 
> support and in 
> which direction it's moving?
> 
> Vlad
> 
> James.Smart@Emulex.Com wrote:
> > Patch 3: 
> >   This patch extends scsi_target support:
> >   - Allows for driver-specific data to be allocated along with the
> >     target structure and accessible via the 
> starget->hostdata pointer.
> >   - Adds scsi target alloc/configure/destory callbacks to the
> >     scsi host template.
> >   - Rearranges the calling sequences for scsi targets so that the
> >     target and slave alloc/configure/destory callbacks are in
> >     order (target before slave on alloc/configure).
> > 
> > -- James S
> 
> 
