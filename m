From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] scsi: arcmsr: add driver module parameter -
 msi_enable, msix_enable
Date: Fri, 24 Nov 2017 17:53:57 +0300
Message-ID: <20171124145357.rtbrqavzne7jkz6l@mwanda>
References: <1511400123.9832.14.camel@Centos6.3-64>
 <20171123125739.GA25627@infradead.org>
 <1511464359.4370.3.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511464359.4370.3.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 24, 2017 at 03:12:39AM +0800, Ching Huang wrote:
> On Thu, 2017-11-23 at 04:57 -0800, Christoph Hellwig wrote:
> > On Thu, Nov 23, 2017 at 09:22:03AM +0800, Ching Huang wrote:
> > > From: Ching Huang <ching2048@areca.com.tw>
> > > 
> > > Hi all,
> > > 
> > > The following patches apply to Martin's 4.16/scsi-queue.
> > > 
> > > Patch 1: Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.
> > > 
> > > Patch 2: Add module parameter msix_enable to has a chance to disable msix interrupt if it does not work properly.
> > 
> > Why would it not work properly?
> This patch is apply to
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/?h=4.16/scsi-queue
>

No, the question is we're adding an option called "msi_enable" which is
used to disable MSI interrupts "if it does not work properly".  Why is
the current code not working properly?

Is there a crash or a performance issue?  What does the bug in the
current code look like from a user perspective?  Can you send us a dmesg
from a failing system?

regards,
dan carpenter
