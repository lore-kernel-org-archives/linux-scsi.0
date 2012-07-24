From: Ani Sinha <ani@aristanetworks.com>
Subject: Re: scsi_requeue_command and dropping reference to sdev_gendev
Date: Tue, 24 Jul 2012 10:29:41 -0700 (PDT)
Message-ID: <alpine.OSX.2.00.1207241023380.2559@animac.local>
References: <CAOxq_8N=t0ramZXQ2O49MbQ2KC3k7D-3Uya93nTo3PY3HhF7Ww@mail.gmail.com> <1343106555.3513.1.camel@dabdike>
Reply-To: ani@aristanetworks.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55719 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2GXR3m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2012 13:29:42 -0400
Received: by gglu4 with SMTP id u4so6927374ggl.19
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2012 10:29:42 -0700 (PDT)
In-Reply-To: <1343106555.3513.1.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Francesco Ruggeri <fruggeri@aristanetworks.com>

>
> commit 940f5d47e2f2e1fa00443921a0abf4822335b54d
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Fri Jun 29 15:34:26 2012 +0000
>
>     [SCSI] Avoid dangling pointer in scsi_requeue_command()
>
> James


Thanks James. We have been only looking at Torvalds' tree and I think this
fix hasn't been pulled in yet. Your pointer is much appreciated.

Cheers,
Ani

