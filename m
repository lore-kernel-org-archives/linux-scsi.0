From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: arm: cumana_1.c:  Remove unused function
Date: Sat, 20 Dec 2014 09:35:53 -0800
Message-ID: <1419096953.2184.3.camel@HansenPartnership.com>
References: <1419093375-8016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <20141220165045.GA5013@hudson.localdomain>
	 <20141220165809.GK11285@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58123 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbaLTRf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2014 12:35:56 -0500
In-Reply-To: <20141220165809.GK11285@n2100.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremiah Mahler <jmmahler@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org

On Sat, 2014-12-20 at 16:58 +0000, Russell King - ARM Linux wrote:
> On Sat, Dec 20, 2014 at 08:50:45AM -0800, Jeremiah Mahler wrote:
> > On Sat, Dec 20, 2014 at 05:36:15PM +0100, Rickard Strandqvist wrote:
> > > Remove the function cumanascsi_setup() that is not used anywhere.
> > > 
> > > This was partially found by using a static code analysis program called cppcheck.
> > > 
> > > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> >
> > You can blame Linus for this one :-)
> > 
> > ~/linux-next$ git blame -L 38,40 drivers/scsi/arm/cumana_1.c 
> > ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 38) void
> > cumanascsi_setup(char *str, int *ints)
> > ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 39) {
> > ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 40) }
> > ~/linux-next$
> 
> Great, that gets me off the hook :)

Well, no, it doesn't: 1da177e is the git tree root commit which was
created by importing the existing bitkeeper version 2.6.12-rc2 into git.
It means this code predates the git import.  You might be able to chase
it through the history tree if you want, but that only goes back as far
as bitkeeper history.

James


