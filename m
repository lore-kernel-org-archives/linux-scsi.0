From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Thu, 03 May 2012 08:40:59 -0400
Message-ID: <4FA27CDB.2080103@teksavvy.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com> <4FA23809.2090905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport-out.teksavvy.com ([206.248.143.162]:23697 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab2ECMlC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2012 08:41:02 -0400
In-Reply-To: <4FA23809.2090905@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-05-03 03:47 AM, Paolo Bonzini wrote:
> Il 02/05/2012 21:38, Mark Lord ha scritto:
>>>>
>>>> Indeed, RHEL doesn't have the warning at all and blocks all ioctls
>>>> including SG_IO (and in the past six months nobody has complained that
>>>> something stopped working for them).  Never said the patch is perfect...
>> hdparm.
>>
> 
> Breaking "hdparm --write-sector /dev/sda1"?  I call it a security fix.

No, that would plain stupid on both our parts.  :)
The --write-sector flag is allowed only for non-partitions by hdparm itself.

But other flags commonly used by distros at boot time
seem to be triggering the current in-kernel noise.
Dunno which flags, I'm just ignoring them and waiting
for the noise message to get reverted.

Cheers

