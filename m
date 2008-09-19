From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: FW: E200i controllers on BL465C Blades - kernel fails to boot
Date: Fri, 19 Sep 2008 19:20:48 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884136A027EA@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20020 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbYISTVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2008 15:21:45 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>

Jens,
This user is complaining of kernels >2.6.24 misbehaving. After 100 or more days all IO gets blocked. Are you aware of any regressions in the block layer? The driver changes that have gone in since 2.6.23-x _shouldn't_ affect the IO path.

Any ideas or thought's are appreciated.

-- mikem

-----Original Message-----
From: Fabio Coatti [mailto:fabio.coatti@gmail.com]
Sent: Tuesday, September 16, 2008 7:32 AM
To: Miller, Mike (OS Dev)
Subject: E200i controllers on BL465C Blades - kernel fails to boot

Hi,
I've spotted your address on lkml and I'm writing to you because we are hit by a very critical bug (or at least we think that it can be  a bug...) I'm referring to the behaviour reported here:

http://lkml.org/lkml/2008/9/14/118

and here:
http://bugzilla.kernel.org/show_bug.cgi?id=9859


I've seen that you looked at this issue in the past (february, lkml mail report by one of my coworkers), but we are still facing tjis issue and we are unable to upgrade our machines (bl465c).

We are in a uncomfortable situation, as we need to upgrade our kernels (for instance, we are seeingd ba behaviour after more or less 100/150 days uptime, with all disk related process in D status, even kjournald -> machine crashes due to load avg skyrocketing. We want to try latest kernel).
Since we have more or less 2 hundreds of BL465C a kernel issue like this can be a bit annoying :) I don't know if we are doing something wrong, but with exactly the same config the older kernel works.
We don't have any problem in trying patches, providing full config or in doing nything useful to get out from this situation. (maybe this is our fault, bu I hardly can imagine how).
Dunno if there are better ways to report this: wa can even try to contact our HP representative, but I'm not convinced that this will be a better solution than reporting the issue on lkml :)

Many thanks for any answer.


--
Fabio "Cova" Coatti    http://members.ferrara.linux.it/cova
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703 Old SysOps never die... they simply forget their password.
