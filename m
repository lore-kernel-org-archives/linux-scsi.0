From: Scott Merritt <Scsi@SpoofWorks.com>
Subject: Re: 2.4.20: possibly wrong handling of removeable scsi disks
Date: Mon, 24 Feb 2003 18:46:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030224184654.26fc1dfc.Scsi@SpoofWorks.com>
References: <3E58BBC3.7020507@domdv.de>
	<20030224231055.GA14101@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030224231055.GA14101@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: linux-scsi@vger.kernel.org

On Tue, 25 Feb 2003 00:10:55 +0100
Andries Brouwer <aebr@win.tue.nl> wrote:

> On Sun, Feb 23, 2003 at 01:17:07PM +0100, Andreas Steinmetz wrote:
> 
> I wrote in 2.5:
> 
>         if (sdkp->media_present)
>                 sd_read_capacity(sdkp, disk->disk_name, SRpnt, buffer);
> 
> That code can be backported.
> 

The code you posted looks great for the problem that I've been having
with empty compact flash card readers.

I would certainly vote for backporting these changes to the 2.4 chain :)
In fact, I'd even offer to attempt the backport myself if we can't
find a more qualified volunteer.

Thanks, Scott.
