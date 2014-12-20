From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] scsi: arm: cumana_1.c:  Remove unused function
Date: Sat, 20 Dec 2014 16:58:09 +0000
Message-ID: <20141220165809.GK11285@n2100.arm.linux.org.uk>
References: <1419093375-8016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141220165045.GA5013@hudson.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141220165045.GA5013@hudson.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 20, 2014 at 08:50:45AM -0800, Jeremiah Mahler wrote:
> On Sat, Dec 20, 2014 at 05:36:15PM +0100, Rickard Strandqvist wrote:
> > Remove the function cumanascsi_setup() that is not used anywhere.
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> You can blame Linus for this one :-)
> 
> ~/linux-next$ git blame -L 38,40 drivers/scsi/arm/cumana_1.c 
> ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 38) void
> cumanascsi_setup(char *str, int *ints)
> ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 39) {
> ^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 40) }
> ~/linux-next$

Great, that gets me off the hook :)

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
