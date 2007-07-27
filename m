From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [3/3] 2.6.23-rc1: known regressions v2
Date: Fri, 27 Jul 2007 22:53:18 +0200
Message-ID: <46AA5B3E.7000106@googlemail.com>
References: <46AA581D.6080100@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:19788 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936022AbXG0U4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 16:56:08 -0400
Received: by ug-out-1314.google.com with SMTP id j3so770821ugf
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jul 2007 13:56:06 -0700 (PDT)
In-Reply-To: <46AA581D.6080100@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>, linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>Adrian Bunk <bunk@stusta.de>

Hi all,

Here is a list of some known regressions in 2.6.23-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2



SCSI

Subject         : lpfc_sli.c: off-by-10
References      : http://lkml.org/lkml/2007/7/22/284
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



USB

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown



Virtualization

Subject         : drivers/net/xen-netfront.c: bogus code
References      : http://lkml.org/lkml/2007/7/22/256
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Jeremy Fitzhardinge <jeremy@goop.org>
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
