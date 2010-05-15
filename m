From: Leif Sawyer <ak.hepcat+scsi@gmail.com>
Subject: Re: Fwd: high volume of disk-writes causes disk to 'disappear'
Date: Sat, 15 May 2010 11:09:14 -0800
Message-ID: <AANLkTik8917n0yNfc9Y6V9rbG7OOltt_SLcxEu8bzu20@mail.gmail.com>
References: <y2wd4bc8f581004191138ldab84bect8670755200e2c413@mail.gmail.com>
	 <w2od4bc8f581004271446md75f0dcbt537956a2e3f9abb7@mail.gmail.com>
	 <4BD99BFD.9090202@suse.de>
	 <q2md4bc8f581004291011k43d5c03cpb7361473f6de4350@mail.gmail.com>
	 <4BDAE41D.6030707@suse.de>
	 <m2gd4bc8f581004301627jea793d0ax1e63bc3796458662@mail.gmail.com>
	 <i2yd4bc8f581005031143r638b8037ra3778f97e6d2e25d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:48424 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0EOTJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2010 15:09:15 -0400
Received: by yxe29 with SMTP id 29so1548493yxe.4
        for <linux-scsi@vger.kernel.org>; Sat, 15 May 2010 12:09:14 -0700 (PDT)
In-Reply-To: <i2yd4bc8f581005031143r638b8037ra3778f97e6d2e25d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, Hannes Reinecke <hare@suse.de>

On a whim, I applied the following patches:
   master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

to my linux 2.6.34-rc5 kernel for testing.

Without the patches, my system would stay running for no more than 2
or three days
before erroring out and requiring a reboot before visibility of the
disk returned.

After applying the SCSI rc fixes from James' git repo, my system is
now at 5+ days
of streaming to the scsi disk.

I'll keep watching this and post another status update in a few days.

Thanks for all the hard work.


-- 
"It's pronounced Layf...you know, like Leif Garrett? Don't you watch
 'I Love the 70's'? What kind of retro lover are you, anyway?"
