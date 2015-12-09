From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] scsi: sim710: fix build warning
Date: Wed, 9 Dec 2015 17:15:51 +0530
Message-ID: <20151209114551.GB24852@sudip-pc>
References: <1441375829-6061-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20150915080000.GE9305@sudip-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150915080000.GE9305@sudip-pc>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 15, 2015 at 01:30:00PM +0530, Sudip Mukherjee wrote:
> On Fri, Sep 04, 2015 at 07:40:29PM +0530, Sudip Mukherjee wrote:
> > We were getting build warning about:
> >  "Section mismatch in reference from the variable sim710_eisa_driver to
> >  the function .init.text:sim710_eisa_probe()
> >  The variable sim710_eisa_driver references the function __init
> >  sim710_eisa_probe()"
> > 
> > sim710_eisa_probe() was having __init but that was being referenced from
> > sim710_eisa_driver.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> A gentle ping.
> I still get the build warning while building for i386 allmodconfig with
> next-20150915.
> Build is at https://travis-ci.org/sudipm-mukherjee/parport/jobs/80365417

Another gentle ping. Build warning with i386 allmodconfig is still there
with next-20151209.
Build log is at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/95746184
 
regards
sudip
