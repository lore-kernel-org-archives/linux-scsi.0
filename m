From: Benjamin LaHaise <bcrl@kvack.org>
Subject: sysfs makes scaling suck Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 13:32:38 -0400
Message-ID: <20070517173238.GA30571@kvack.org>
References: <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com> <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com> <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk> <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kanga.kvack.org ([66.96.29.28]:57793 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935AbXEQRc7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2007 13:32:59 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On Wed, May 16, 2007 at 04:57:52AM +0530, Satyam Sharma wrote:
> 
> echo 1 > /sys/module/scsi_mod/.../wait_for_async_scans
> 
> somewhere in some script. In fact, the latter method seems simpler,
> saner, better (in every which way)!

Please don't force sysfs on people.  Just watch how it keels over and dies 
when you end up with lots of disks/network interfaces on reasonably sized 
boxes.  16 statically allocated files per network interface starts being 
a problem once you've got a few thousand interfaces.  Anything that forces 
me to use sysfs is not gonna fly.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
