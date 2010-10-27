From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Subject: Re: MPT2SAS deadlocking on failed disk
Date: Wed, 27 Oct 2010 20:19:22 GMT
Message-ID: <0AFF9SA11@briare1.fullpliant.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from briare1.fullpliant.org ([78.227.24.35]:47194 "HELO
	briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751742Ab0J0TOB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 15:14:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>

Hi,

> Louis-David Mitterrand wrote:
>
> FWIW I had horrible problems on 2.6.35.x (grml) with the mpt2sas driver
> (like running lilo would eject most disks in a running raid6).
>
> All these problems went away with 2.6.36.

I did the same experiment on 2.6.36: the result is the same.
What is still not clear is: is the problem in MD software RAID, or in mpt2sas ?

Regards,
Hubert Tonneau


Hubert Tonneau wrote:
>
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
> 
> Regards,
> Hubert Tonneau

