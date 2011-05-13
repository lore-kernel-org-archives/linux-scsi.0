From: Billy Crook <billycrook@gmail.com>
Subject: Re: mpt2sas: bug in disk ordering?
Date: Fri, 13 May 2011 07:03:55 -0500
Message-ID: <BANLkTinsvVTfsJJVRU3o6S7HiOh5RwU9_Q@mail.gmail.com>
References: <BANLkTi=SsdjeHJOU_we+kZMgM0qm7eaVjg@mail.gmail.com>
 <BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com> <B2FD678A64EAAD45B089B123FDFC3ED70157F7BB82@inbmail01.lsi.com>
 <BANLkTikaFkeEaTPutOuMAnUx5gvdP=JyJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35214 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1EMMEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 08:04:36 -0400
Received: by bwz15 with SMTP id 15so2063130bwz.19
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2011 05:04:35 -0700 (PDT)
In-Reply-To: <BANLkTikaFkeEaTPutOuMAnUx5gvdP=JyJQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Fri, May 13, 2011 at 06:46, Caspar Smit <c.smit@truebit.nl> wrote:
> But when i use a LSI 3081E-R HBA (mptsas driver) the disk ordering is
> ALWAYS the same, and always in correct order.
> I would like to keep that functionality when upgrading to the newer 9211-8i HBA.

That was an unintentional coincidence. Consider yourself lucky nothing
was destroyed during the time you assumed it was deterministic.  Disk
ordering is essentially random in Linux, and will continue to be,
indefinitely.  If being able to refer to specific disks is important,
use the links in /dev/disk/ or assign the disks LABELs and use those
or UUIDs.  If /dev/disk is gone or not working, that is the problem
you need to solve, NOT disk startup order.
