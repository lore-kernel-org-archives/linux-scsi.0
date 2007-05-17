From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: sysfs makes scaling suck Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 13:49:52 -0400
Message-ID: <20070517174952.GB30571@kvack.org>
References: <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk> <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com> <20070517173238.GA30571@kvack.org> <1179423924.3785.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kanga.kvack.org ([66.96.29.28]:57915 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760263AbXEQRtz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2007 13:49:55 -0400
Content-Disposition: inline
In-Reply-To: <1179423924.3785.30.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On Thu, May 17, 2007 at 01:45:24PM -0400, James Bottomley wrote:
> But also, the sysfs with over 4,000 (and higher) devices was
> specifically checked by OSDL (actually as part of the CGL testing) some
> of the Manoj changes (for unpinning entries etc) were needed to get it
> to function, but as of now, I believe an enterprise scaling test works
> reasonably well for it ... there certainly wasn't any evidence of it
> dying horribly in the tests.

i386 exhausts lowmem very quickly.  SCSI is in a bit better shape than 
network devices as the multiplier is only around 4 compared to 16 for network 
devices.

My point stands, though.  Forcing every new feature to go in via sysfs is 
not the right thing to do.  Some people don't/can't use it, please remember 
them.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
