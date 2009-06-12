From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Return of PENDING status to SCSI driver
Date: Fri, 12 Jun 2009 18:24:46 +0530
Message-ID: <3e7aae30906120554u189d4abdye0f40cd2ddc12f58@mail.gmail.com>
References: <3e7aae30906120229p3bbeb7f0jd07c5f1e823a456a@mail.gmail.com>
	 <4A323CE8.7010207@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:45044 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760056AbZFLNA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 09:00:56 -0400
Received: by qyk4 with SMTP id 4so211782qyk.33
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 06:00:58 -0700 (PDT)
In-Reply-To: <4A323CE8.7010207@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 6/12/09, Jeff Garzik <jeff@garzik.org> wrote:
> Ramya Desai wrote:
>
> > Dear Experts,
> >
> > I am writing my mass storage class driver for my custom USB device.
> > My device is capable of queuing the commands that are issued to it.
> > So, I wanted to send the second command from my driver even before the
> > completion of first command.
> > To do this I wanted to return the PENDING status to the SCSI layer
> > immediately after receiving the command.
> >
>
>  Simply queue as many commands as possible to your hardware, and complete
> them when they are done.  Use can_queue or scsi_adjust_queue_depth() to set
> queueing limits.
>
>         Jeff

I used can_queue  to change the queue depth to 5, but I am not getting
the next command until I finish (Done) the first command. I wanted the
second command to come to my driver, even before first command
finishes.

-RD
