From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] scsi: sim710: fix build warning
Date: Sat, 9 Jan 2016 13:12:06 +0530
Message-ID: <20160109074206.GA27241@sudip-pc>
References: <1441375829-6061-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20150915080000.GE9305@sudip-pc>
 <20151209114551.GB24852@sudip-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36621 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbcAIHmR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2016 02:42:17 -0500
Content-Disposition: inline
In-Reply-To: <20151209114551.GB24852@sudip-pc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Wed, Dec 09, 2015 at 05:15:51PM +0530, Sudip Mukherjee wrote:
> On Tue, Sep 15, 2015 at 01:30:00PM +0530, Sudip Mukherjee wrote:
> > On Fri, Sep 04, 2015 at 07:40:29PM +0530, Sudip Mukherjee wrote:
> > > We were getting build warning about:
> > >  "Section mismatch in reference from the variable sim710_eisa_driver to
> > >  the function .init.text:sim710_eisa_probe()
> > >  The variable sim710_eisa_driver references the function __init
> > >  sim710_eisa_probe()"
> > > 
> > > sim710_eisa_probe() was having __init but that was being referenced from
> > > sim710_eisa_driver.
> > > 
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > ---
> > A gentle ping.
> > I still get the build warning while building for i386 allmodconfig with
> > next-20150915.
> > Build is at https://travis-ci.org/sudipm-mukherjee/parport/jobs/80365417
> 
> Another gentle ping. Build warning with i386 allmodconfig is still there
> with next-20151209.
> Build log is at:
> https://travis-ci.org/sudipm-mukherjee/parport/jobs/95746184

Another gentle ping. Build warning with i386 allmodconfig is still there
with next-20160108.
Build log is at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/101006139

regards
sudip
