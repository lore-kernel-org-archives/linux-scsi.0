From: Andres Freund <andres@anarazel.de>
Subject: Re: 2.6.31-rc2: Reported regressions from 2.6.30
Date: Tue, 7 Jul 2009 03:25:51 +0200
Message-ID: <200907070325.51439.andres@anarazel.de>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
Sender: netdev-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Natalie Protasevich <protasnb@gmail.com>, Kernel Testers List <kernel-testers@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, DRI <dri-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Hi Rafael,

On Tuesday 07 July 2009 01:42:09 Rafael J. Wysocki wrote:
> If you know of any other unresolved regressions from 2.6.30, please let me
> know either and I'll add them to the list.  Also, please let me know if any
> of the entries below are invalid.
There is also http://lkml.org/lkml/2009/6/30/398 : Soft-Lockup/Race in 
networking in 2.6.31-rc1+195 (possibly caused by netem)


Andres
