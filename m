From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PATCH 2.6.11-rc4 rename IOMAPPED config option
Date: Mon, 21 Feb 2005 02:26:40 +0000
Message-ID: <20050221022640.GC28741@parcelfarce.linux.theplanet.co.uk>
References: <20050221010758.GC30800@colo.lackof.org> <4219355E.1000807@pobox.com> <20050221020221.GA28741@parcelfarce.linux.theplanet.co.uk> <20050221020936.GA22713@havoc.gtf.org> <20050221021405.GB28741@parcelfarce.linux.theplanet.co.uk> <20050221021631.GA23161@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:50360 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261548AbVBUC0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 21:26:42 -0500
Content-Disposition: inline
In-Reply-To: <20050221021631.GA23161@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Grant Grundler <grundler@parisc-linux.org>, willy@parisc-linux.org, linux-scsi@vger.kernel.org

On Sun, Feb 20, 2005 at 09:16:31PM -0500, Jeff Garzik wrote:
> On Mon, Feb 21, 2005 at 02:14:05AM +0000, Matthew Wilcox wrote:
> > On Sun, Feb 20, 2005 at 09:09:36PM -0500, Jeff Garzik wrote:
> > > Incorrect.  <linux/config.h> is not a standard include; you need to
> > > include linux/config.h in each file that uses a CONFIG_xxx define.
> > 
> > sym_hipd.c includes "sym_glue.h"
> > sym_glue.h includes <linux/config.h>
> > There is no problem.
> 
> Irrelevant.  Go look at how config.h stuff works.
> 
> linux/config.h is a special case with special rules.
> 
> The rule is:  include linux/config.h _in the file_ where CONFIG_xxx
> symbol is used.

Jeff, you're smoking crack.  I just read fixdep.c and looked at
drivers/scsi/sym53c8xx_2/.sym_hipd.o.cmd .  You're wrong.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
