From: Otto Solares <solca@guug.org>
Subject: Re: aacraid, seagate and adaptec issues [Was: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/Di Container goes offline]
Date: Wed, 10 Nov 2004 15:08:24 -0600
Message-ID: <20041110210824.GD8047@guug.org>
References: <20041028005302.753a2d52.akpm@osdl.org> <418138B6.2010104@brutsche.us> <1100031774.24635.157.camel@ryan2.internal.autoweb.net> <20041109213215.GA4047@guug.org> <20041110174346.GA8047@guug.org> <41927B0F.6000902@brutsche.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from guug.org ([168.234.203.30]:19278 "EHLO guug.org")
	by vger.kernel.org with ESMTP id S261995AbUKJVI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 16:08:28 -0500
Content-Disposition: inline
In-Reply-To: <41927B0F.6000902@brutsche.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Brutsche <phil@brutsche.us>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2004 at 02:33:19PM -0600, Phil Brutsche wrote:
> Otto Solares wrote:
> 
> > A seagate time-out issue with exactly my disks:
> > 
> > http://www.seagate.com/support/disc/u320_firmware.html
> 
> [...]
> 
> > Does anybody have this seagate firmware updates?
> 
> I have a pair of RAID5s with these Seagate drives; I have flashed the
> firmware on the affected drives to the latest 0006 rev (they are 15k RPM
> drives).

I have Dell servers with the following disks:

SPEED BRAND   MODEL     REV
10K   SEAGATE ST3146807 DS09
15K   SEAGATE ST373453  DX10

Clearly they are affected by the _time_out_ issue.

They are in RAID1 configurations.  I couldn't obtain the
firmware from Dell nor Seagate, how do you obtain the
firmware updates?

-otto
