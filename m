From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.39-rc3-git3 problem etc , reset-resistent problem
Date: Fri, 22 Apr 2011 20:35:25 +0200
Message-ID: <20110422183525.GE21902@mtj.dyndns.org>
References: <web-506519881@zbackend1.aha.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44721 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1DVSfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2011 14:35:31 -0400
Received: by eyx24 with SMTP id 24so244434eyx.19
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2011 11:35:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <web-506519881@zbackend1.aha.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: werner <w.landgraf@ru.ru>
Cc: axboe@kernel.dk, James.Bottomley@HansenPartnership.com, mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org

Hello, werner.

On Sun, Apr 17, 2011 at 02:38:58AM -0400, werner wrote:
> Enclosed pls find a screen foto of another crash with this
> reset-resistent problem.

What do you mean by reset-resistant?

> As said, after patching blk and scsi in 2.6.39-rc3-git4 as someone
> suggested me to try out, happened crashs short  or longer time after
> booting, which caused a rather early crash during subsequent boots,
> which don't go away  even after re-set or power-off, and occurs
> again and again with 2.6.39-rcX  .  This goes away only if I boot
> with 2.6.38.2 or .3 ; in this case, if after this I boot again with
> 2.6.39-rc3-git4+patches, then repeats the same, i.e. the first time
> it crashs only after the end of booting, but subsequently again in
> the early stage.
> 
> I think this is a khugepaged problem, or that the computer wrongly
> interpretes the video card or anything else as an scsi or blk
> device.  At least subjectively, the sticking after booting is very
> similar to the khugepaged problem which I reclaimed during
> 2.6.38-rc1 (or was it .37-rc1 ), and which then was corrected, but
> perhaps it wasn't corrected really and now comes back.

Unfortunately, I can't really make much sense of your report and the
screenshot seems already deep into multiple failures making it very
difficult to tell what initiated the whole situation.  As Jens
requested before, can you please setup serial or netconsole and try to
capture the full kernel log from boot to crash?

Thank you.

-- 
tejun
