From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 15:43:26 -0400
Message-ID: <20070517194326.GC30571@kvack.org>
References: <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com> <20070516025121.GK10562@parisc-linux.org> <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com> <20070517185115.GA13207@infradead.org> <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com> <20070517193953.GM10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761091AbXEQUNP@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070517193953.GM10562@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Christoph Hellwig <hch@infradead.org>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 17, 2007 at 01:39:54PM -0600, Matthew Wilcox wrote:
> On Fri, May 18, 2007 at 12:34:40AM +0530, Satyam Sharma wrote:
> > Hmmm, actually those other users could easily write and maintain
> > a 20-line patch that does the wait for async scans thing for them
> > using /proc/scsi/scsi in any case.
> 
> How about the three users who're bothered by this extra module being
> built maintain a one-line patch to Kconfig and leave well enough alone?

The module has an added bonus that it doesn't require any new tools to 
make work.  Doing it via sysfs/procfs means a new rev of whatever tool 
generates the boot initrd, plus fixing up boot scripts.  Loading a module 
can be done via a simple option to the existing boot tools.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
