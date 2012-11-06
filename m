From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: build failure after merge of the pci tree
Date: Tue, 6 Nov 2012 02:55:42 +0100
Message-ID: <20121106015542.GA13487@kroah.com>
References: <20121106112729.994c25ccce521ab5aaf1f060@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121106112729.994c25ccce521ab5aaf1f060@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Achim Leubner <achim_leubner@adaptec.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-next@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 06, 2012 at 11:27:29AM +1100, Stephen Rothwell wrote:
> Hi Bjorn,
> 
> After merging the pci tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/staging/telephony/ixj.c: In function 'ixj_probe_pci':
> drivers/staging/telephony/ixj.c:7732:13: warning: assignment makes integer from pointer without a cast [enabled by default]
> drivers/staging/telephony/ixj.c:7732:38: error: expected ';' before 'pci_resource_start'
> 
> Exposed by commit 545974a28f78 ("PCI: Convert pci_resource_<foo> macros to
> static inlines").  The macro version of pci_resource_start() made this
> RHS look like a function call and now it isn't.
> 
> Maybe it is time this driver just went away.

It is gone in my tree, and it should be deleted in yours, do you not see
that?

thanks,

greg k-h
