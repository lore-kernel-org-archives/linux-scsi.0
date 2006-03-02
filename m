From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: sg regression in 2.6.16-rc5
Date: Fri, 3 Mar 2006 00:06:45 +0100
Message-ID: <20060302230645.GA16237@merlin.emma.line.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net> <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org> <4405F6F1.9040106@torque.net> <Pine.LNX.4.63.0603012239440.5789@kai.makisara.local> <44074CA1.3000007@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:30436 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751056AbWCBXGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 18:06:51 -0500
Content-Disposition: inline
In-Reply-To: <44074CA1.3000007@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Linus Torvalds <torvalds@osdl.org>, Matthias Andree <matthias.andree@gmx.de>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org

On Thu, 02 Mar 2006, Douglas Gilbert wrote:

> In 8 years of maintaining the sg driver I cannot remember
> anybody contacting me regarding the way the sg driver ignored
> the DISABLE_CLUSTERING flag; that was until Mike Christie raised
> it yesterday with regard to iscsi_tcp ***. Gerard's post from
> 2000 implied clustering was not a problem with U160 (SPI-3)
> so perhaps it was for SPI-2 (1998) or SPI (1995) or SCSI-2 (1993).
> If so those are pretty old symbios controllers. Why would any
> storage manufacturer make a DMA element that was restricted
> to Intel's i386 page size per transfer?

Well, second-hand hardware like that isn't too uncommon for backups,
U2W adaptors such as Tekram DC-390U2B/U2W (SYM53C895) can be had for a
song, and so can U2W tape drives (Tandberg SLR6/SLR24, SLR32, SLR7).
On the other hand, it's not like people would update their backup
host kernels every week either, so the pain would spread slowly before
becoming really prominent.

(dropped linux-kernel@ from the cc: list, linux-scsi@ should be
sufficient)

-- 
Matthias Andree
