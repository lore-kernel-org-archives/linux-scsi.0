From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Sun, 21 Aug 2005 22:15:40 -0500
Message-ID: <1124680540.5068.37.camel@mulgrave>
References: <20050822003325.33507.qmail@web51613.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932182AbVHVXBE@vger.kernel.org>
In-Reply-To: <20050822003325.33507.qmail@web51613.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: luben_tuikov@adaptec.com
Cc: Andrew Morton <akpm@osdl.org>, Jim Houston <jim.houston@ccur.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2005-08-21 at 17:33 -0700, Luben Tuikov wrote:
> No preallocation is done from IRQ context.  Do not spread FUD.
> It seems to me that you're unaware how IDR works and unaware how
> the driver works.

Argumentum ad Hominem now ... we'll get them all eventually.

Since you won't post the usage code, just answer this: how does what
you're doing with idr differ from its originally designed consumer: the
posix timers which also do the idr_remove() in IRQ context?

To me it seems your argument applies to this case as well, but you
didn't quote it when asked for an example, so I assume there's some
difference that I don't understand.

James
