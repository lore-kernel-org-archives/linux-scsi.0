From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Help - looking for a Linux SCSI testing utility
Date: Thu, 27 May 2004 21:55:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040527195501.GA6400@harddisk-recovery.nl>
References: <1F6D1D1660975A4887628A011443A1BC0305E3D0@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from users.linvision.com ([62.58.92.114]:30683 "HELO bitwizard.nl")
	by vger.kernel.org with SMTP id S265117AbUE0TzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 15:55:03 -0400
Content-Disposition: inline
In-Reply-To: <1F6D1D1660975A4887628A011443A1BC0305E3D0@uswaumsx13medge.med.ge.com>
List-Id: linux-scsi@vger.kernel.org
To: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Cc: linux-scsi@vger.kernel.org

On Thu, May 27, 2004 at 02:41:01PM -0500, Edwards, Scott (MED, Kelly IT Resouces) wrote:
> I'm starting to think I have the Midas Touch in reverse.  This looked like
> it was going to be a winner, but when I run it, it says the Write Cache is
> off.  I'm fairly certain this is not the case, as the manufacturer rep has
> confirmed that the default is on, I've hooked it to a different OS and it
> says it's on, and all of the journaling file systems (Reiser, XFS, JFS,
> ext3) completely fail (which is how I got into this mess in the first
> place).

Use the -M and -S flags to select which information you want to see. -M
selects manufacturers defaults, -S saved data. scsiinfo defaults to
"current" settings.

> Just for grins I tried to set it on with scsiinfo and it came back and said
> the write mode page failed.  I am wondering if because the drive is a Serial
> ATA drive and not a real SCSI drive if the mode page stuff works on it?  The
> manual the mfr sent says to send an EF command with either a 02/82 to
> enable/disable the write cache.  I didn't see anything in there about mode
> pages.

The example I gave was from an old Seagate ST39140N drive that was
lying on my desk. AFAIK scsiinfo will not work with non-SCSI devices.
For ATA drives, hdparm -W 0 should disable the write cache.

> Anyway, thanks, you at least gave me a glimmer of hope this morning.  I was
> getting pretty discouraged by yesterday afternoon.  I'm going to dig around
> in the scsiinfo source and see if I can figure something out.

FWIW: I just tracked down a bug in scsiformat. Tomorrow I need to
figure out if I'm right or just tired %-).


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
| Data lost? Stay calm and contact Harddisk-recovery.com
