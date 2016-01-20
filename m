From: Alexandre Rossi <alexandre.rossi@gmail.com>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Wed, 20 Jan 2016 23:07:29 +0100
Message-ID: <CAM79t8GJvQPzOt1oDikxv3wPZ9xgVMez5EUgXmeVH2zKJCeaAw@mail.gmail.com>
References: <1453222373.3588.3.camel@giantmonkey.de>
	<Pine.LNX.4.44L0.1601191532210.1312-200000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:32888 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935093AbcATWH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 17:07:29 -0500
Received: by mail-ig0-f178.google.com with SMTP id z14so110892696igp.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 14:07:29 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1601191532210.1312-200000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul Menzel <paul.menzel@giantmonkey.de>, Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org

Hi,

>> Could you please attach the debugging patch. Hopefully Alexandre, Erich,
>> or I will have some spare time to build an image from it.
>
> Actually, this patch is an attempt at a fix.  After looking more
> carefully at your log pictures, I realized what the problem must be.
>
> It's too bad nobody was able to capture a log where the error
> occurred in sr_runtime_suspend, though -- all the logs in the bug
> report show sd_runtime_resume.

I just tested the patch applied on top of 4.3.3 (4.3.3-6 in Debian).

It still crashes at boot, but the stacktrace is different : it happens
in blk_post_runtime_resume . Maybe I'm bit by a different bug or maybe
the I need to try with 4.4.

I'll post the captured log when I have access to a wired network. I'd
be happy to provide the logs of a debugging patch.

Alex
