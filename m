From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 04 May 2012 08:39:22 +0200
Message-ID: <4FA3799A.6010908@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com> <4FA23809.2090905@redhat.com> <4FA27CDB.2080103@teksavvy.com> <4FA27E7C.6070802@redhat.com> <4FA2C205.3030801@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:65353 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2EDGj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 02:39:27 -0400
In-Reply-To: <4FA2C205.3030801@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Il 03/05/2012 19:36, Mark Lord ha scritto:
>> > Excuse my laziness--how does it check?
> I don't know if there's a feasible fool-proof method or not.
> But what hdparm does is look at the sector offset of the device.
> Partitions normally have a non-zero offset.

Yeah, that should work.

>>> >> But other flags commonly used by distros at boot time
>>> >> seem to be triggering the current in-kernel noise.
>>> >> Dunno which flags, I'm just ignoring them and waiting
>>> >> for the noise message to get reverted.
>> > 
>> > That's exactly the behavior I hoped to get when I added the warnings.
>> > Or maybe not. :)  What are the messages?
>> > i.e. what ioctl do they complain about?
> As above:
> 
>>> >> Dunno which flags, I'm just ignoring them and waiting
>>> >> for the noise message to get reverted.

I said which ioctls, not which options.  I.e. cut-and-paste from dmesg.

Paolo
