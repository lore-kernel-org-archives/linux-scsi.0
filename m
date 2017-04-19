From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] scsi: osd_uld: fix mismerge
Date: Thu, 20 Apr 2017 09:29:25 +1000
Message-ID: <20170420092925.400cb477@canb.auug.org.au>
References: <20170419174415.4029467-1-arnd@arndb.de>
        <1492624001.2543.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1492624001.2543.9.camel@sandisk.com>
Sender: linux-next-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ooo@electrozaur.com" <ooo@electrozaur.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bhalevy@primarydata.com" <bhalevy@primarydata.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Greg KH <greg@kroah.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

On Wed, 19 Apr 2017 17:46:43 +0000 Bart Van Assche <Bart.VanAssche@sandisk.com> wrote:
>
> On Wed, 2017-04-19 at 19:44 +0200, Arnd Bergmann wrote:
> > Fixes: c02465fa13b6 ("scsi: osd_uld: Check scsi_device_get() return value")
> > Fixes: ac1ddc584e98 ("scsi: utilize new cdev_device_add helper function")  
> 
> Both these patches are fine as far as I can tell. Shouldn't the
> "Fixes" tag refer to the merge commit instead of to the commits
> that have been merged?

Unfortunately, the merge commit is redone every day and will be redone
by Linus during the merge window.  This fix should be incorporated into
the merge commit itself.  I should have done it originally, but the
conflict was such a mess that I took the easy way out :-)
-- 
Cheers,
Stephen Rothwell
