From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: Re: MPT2SAS deadlocking on failed disk
Date: Sun, 24 Oct 2010 22:28:56 +0200
Message-ID: <20101024202856.GA15596@apartia.fr>
References: <0AF91KJ@briare1.fullpliant.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:60653 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab0JXU26 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2010 16:28:58 -0400
Content-Disposition: inline
In-Reply-To: <0AF91KJ@briare1.fullpliant.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Oct 24, 2010 at 11:36:18AM +0000, Hubert Tonneau wrote:
> Hi,
> 
> In stock Linux 2.6.35.7 kernel,
> with mpt2sas driver connected to two disks (no raid at controler level),
> and Linux MD software RAID1,
> 
> if I hot unplug one of the disks,
> instead of the failed disk beeing removed from the MD raid set,
> I get locked disk subsystem with all applications trying to write to
> the disks beeing locked. No kernel message related to disks, only
> to applications beeing locked.
> 
> This bug is probably not related specificaly to kernel 2.6.35.7
> because I had not used LSI controlers for years.

FWIW I had horrible problems on 2.6.35.x (grml) with the mpt2sas driver
(like running lilo would eject most disks in a running raid6).

All these problems went away with 2.6.36.
