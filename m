From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Date: Wed, 08 Aug 2007 19:12:35 +0200
Message-ID: <46B9F983.9020700@googlemail.com>
References: <46B9F664.9060600@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S937016AbXHHRNn@vger.kernel.org>
In-Reply-To: <46B9F664.9060600@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Andrew Vasquez <linux-driver@qlogic.com>, Zhang Yanmin <yanmin_zhang@linux.intel.com>, linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>, Mark Hindley <mark@hindley.org.uk>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Oliver Falk <oliver@linux-kernel.at>
List-Id: linux-scsi@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2
Peter Zijlstra                         2
Trent Piepho                           2



Power management

Subject         : Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
References      : http://lkml.org/lkml/2007/8/4/39
Last known good : ?
Submitter       : Meelis Roos <mroos@linux.ee>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : unknown



SCSI

Subject         : unable to handle kernel NULL pointer dereference in qla2x00_read_nvram_data
References      : http://lkml.org/lkml/2007/8/6/506
Last known good : ?
Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



USB

Subject         : 2.6.23-rc1: uhci_hcd. irq 4: nobody cared
References      : http://lkml.org/lkml/2007/7/29/75
Last known good : ?
Submitter       : Mark Hindley <mark@hindley.org.uk>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Status          : unknown

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown



Alpha

Subject         : -Werror compilation problem - make[1]: *** [arch/alpha/kernel/sys_titan.o] Error 1
References      : http://lkml.org/lkml/2007/8/6/137
Last known good : ?
Submitter       : Oliver Falk <oliver@linux-kernel.at>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
