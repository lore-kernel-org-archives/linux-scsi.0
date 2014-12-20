From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] scsi: arm: cumana_1.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:39:04 +0000
Message-ID: <20141220173904.GL11285@n2100.arm.linux.org.uk>
References: <1419093375-8016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141220165045.GA5013@hudson.localdomain>
 <20141220165809.GK11285@n2100.arm.linux.org.uk>
 <1419096953.2184.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1419096953.2184.3.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-kernel@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>, Jeremiah Mahler <jmmahler@gmail.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 20, 2014 at 09:35:53AM -0800, James Bottomley wrote:
> On Sat, 2014-12-20 at 16:58 +0000, Russell King - ARM Linux wrote:
> > On Sat, Dec 20, 2014 at 08:50:45AM -0800, Jeremiah Mahler wrote:
> > > On Sat, Dec 20, 2014 at 05:36:15PM +0100, Rickard Strandqvist wrote:
> > > > Remove the function cumanascsi_setup() that is not used anywhere.
> > > > 
> > > > This was partially found by using a static code analysis program called cppcheck.
> > > > 
> > > > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > >
> > > You can blame Linus for this one :-)
> > > 
> > > ~/linux-next$ git blame -L 38,40 drivers/scsi/arm/cumana_1.c 
> > > ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 38) void
> > > cumanascsi_setup(char *str, int *ints)
> > > ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 39) {
> > > ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 40) }
> > > ~/linux-next$
> > 
> > Great, that gets me off the hook :)
> 
> Well, no, it doesn't: 1da177e is the git tree root commit which was
> created by importing the existing bitkeeper version 2.6.12-rc2 into git.
> It means this code predates the git import.  You might be able to chase
> it through the history tree if you want, but that only goes back as far
> as bitkeeper history.

James, please see the smilie on the end of the comment, I wasn't being
serious.  Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
