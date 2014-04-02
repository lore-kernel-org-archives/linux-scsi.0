From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH RESEND] scsi_transport_sas: move bsg destructor into
 sas_rphy_remove
Date: Wed, 2 Apr 2014 16:48:52 -0400
Message-ID: <20140402164852.1f20ccb6@jlaw-desktop.mno.stratus.com>
References: <1396471241-1315-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o145.mxlogic.net ([208.65.144.78]:54461 "EHLO
	p02c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbaDBUs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2014 16:48:57 -0400
In-Reply-To: <1396471241-1315-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Dan Williams <dan.j.williams@intel.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>

On Wed, 2 Apr 2014 16:40:41 -0400
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> Since bsg creation is a side effect of sas_rphy_add, move its
> complementary removal call into sas_rphy_remove. 

Hello James,

This a resend of a patch posted to quiet an end-device sysfs warning in
its device deletion path when removing the mpt2sas driver:

  (initial report)
  sysfs group not found for kobject on mpt2sas unload
  http://marc.info/?t=138497460000004
  
  (patch + ACK + comments)
  http://marc.info/?t=138609455500001

  (gentoo, LSI repro)
  mpt2sas driver barfs when force removing a drive on 3.13.1
  http://marc.info/?t=139122351300001

Dan Williams had a few other suggestions for cleanup in this area, but
those could be handled in a subsequent patch.  This one missed 3.14
inclusion and the warning still occurs in Linus's tree as of today
(post scsi/block merge) hence the repost.

Regards,

-- Joe
