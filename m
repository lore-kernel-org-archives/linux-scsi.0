From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 08:14:01 +0100
Message-ID: <47A80CB9.9000805@wpkg.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com> <1201710175.3292.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.syneticon.net ([213.239.212.131]:42021 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYBEHOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 02:14:10 -0500
In-Reply-To: <1201710175.3292.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

James Bottomley schrieb:

> These are both features being independently worked on, are they not?
> Even if they weren't, the combination of the size of SCST in kernel plus
> the problem of having to find a migration path for the current STGT
> users still looks to me to involve the greater amount of work.

I don't want to be mean, but does anyone actually use STGT in
production? Seriously?

In the latest development version of STGT, it's only possible to stop
the tgtd target daemon using KILL / 9 signal - which also means all
iSCSI initiator connections are corrupted when tgtd target daemon is
started again (kernel upgrade, target daemon upgrade, server reboot etc.).

Imagine you have to reboot all your NFS clients when you reboot your NFS
server. Not only that - your data is probably corrupted, or at least the
filesystem deserves checking...


-- 
Tomasz Chmielewski
http://wpkg.org



