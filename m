From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH RESEND] scsi_transport_sas: move bsg destructor into
 sas_rphy_remove
Date: Fri, 2 May 2014 15:01:32 -0400
Message-ID: <20140502150132.6ddd8a0c@jlaw-desktop.mno.stratus.com>
References: <1396471241-1315-1-git-send-email-joe.lawrence@stratus.com>
	<20140402164852.1f20ccb6@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o144.mxlogic.net ([208.65.145.77]:57760 "EHLO
	p02c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaEBTBj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2014 15:01:39 -0400
In-Reply-To: <20140402164852.1f20ccb6@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Dan Williams <dan.j.williams@intel.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>

On Wed, 2 Apr 2014 16:48:52 -0400
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> On Wed, 2 Apr 2014 16:40:41 -0400
> Joe Lawrence <joe.lawrence@stratus.com> wrote:
> 
> > Since bsg creation is a side effect of sas_rphy_add, move its
> > complementary removal call into sas_rphy_remove. 
> 
> Hello James,
> 
> This a resend of a patch posted to quiet an end-device sysfs warning in
> its device deletion path when removing the mpt2sas driver:
> 
>   (initial report)
>   sysfs group not found for kobject on mpt2sas unload
>   http://marc.info/?t=138497460000004
>   
>   (patch + ACK + comments)
>   http://marc.info/?t=138609455500001
> 
>   (gentoo, LSI repro)
>   mpt2sas driver barfs when force removing a drive on 3.13.1
>   http://marc.info/?t=139122351300001
> 
> Dan Williams had a few other suggestions for cleanup in this area, but
> those could be handled in a subsequent patch.  This one missed 3.14
> inclusion and the warning still occurs in Linus's tree as of today
> (post scsi/block merge) hence the repost.

Ping? Just reproduced on 3.15-rc3.  Also found this:

  (~500 repro count on Fedora Problem Tracker)
  http://retrace.fedoraproject.org/faf/problems/1623421/

-- Joe
