From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Tue, 13 Apr 2010 13:45:20 -0700
Message-ID: <1271191520.32337.77.camel@haakon2.linux-iscsi.org>
References: <4BB45632.5020700@suse.de> <4BC099C5.9090704@vlnb.net>
	 <4BC431C8.9020800@suse.de>  <4BC4A559.4090806@vlnb.net>
	 <1271183865.32337.39.camel@haakon2.linux-iscsi.org>
	 <4BC4C4C9.70103@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:40970 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752970Ab0DMUqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 16:46:54 -0400
In-Reply-To: <4BC4C4C9.70103@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Hannes Reinecke <hare@suse.de>, lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2010-04-13 at 23:23 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 04/13/2010 10:37 PM wrote:
> > On Tue, 2010-04-13 at 21:09 +0400, Vladislav Bolkhovitin wrote:
> >> LIO doesn't support 1 to many pass-through devices sharing, so SCST in 
> >> the only option.
> > 
> > Sorry, but this statement about your perceived limitiations wrt TCM/LIO
> > is completely incorrect.
> > 
> > Using a single passthrough backstore device (eg: plain /dev/sdX) with
> > TCM/pSCSI (or any TCM subsystem plugin) has been supported since the
> > dawn of time to allow for any number of TCM_Loop Virtual SAS Ports with
> > SG_IO going into KVM Guest.  The same is also true for LIO-Target
> > (iSCSI) and TCM_FC (FCoE) ports as well regardless of TCM subsystem
> > backstore.
> > 
> > Perhaps you would be so kind to provide a TCM/LIO source code reference
> > from where you came up with this make-believe notion..?
> 
> I've just rechecked with the latest 
> git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git and 
> still wasn't able to find in LIO required pieces of functionality to 
> support 1 to many pass-through. I see only code for non-enforced 1 to 1 
> pass-through (single initiator only). You can use with it more 
> initiators only as the SCSI violation, from pointing on which I started 
> my participation in this discussion.
> 

Sorry, but listing the path to my git tree on k.o is not the same as
citing a actual TCM/LIO source+line reference.

> Particularly, I can't see the code, which in pass-through mode upon 
> receive of RESERVE command sends it also to the backend device, if 
> necessary (i.e. only the first time), and then sends RELEASE command to 
> the device upon the reservation holder removal. Could you point me on 
> the *exact* code which implements that?
> 

Again, since *you* are the one making a claim, *you* are the one
expected to back it up with a concrete code reference and example
scenario.   Please, do the leg-work yourself wrt TCM SPC-3 persisetent
reservations and legacy SPC-2 reservations instead of expecting me to do
the actual work for you to verify your own fanciful claims about target
mode, seriously..

So, short of you being able to produce a response that is concrete and
human-readable, your claim will once again be dismissed as generic
hand-waving.

--nab

