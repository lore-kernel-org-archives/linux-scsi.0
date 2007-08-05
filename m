From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [3/3] 2.6.23-rc2: known regressions
Date: Sun, 05 Aug 2007 10:59:16 -0700
Message-ID: <46B60FF4.3070208@goop.org>
References: <46B5F74D.7010708@googlemail.com> <46B5FA39.5050907@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:50306 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbXHESAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Aug 2007 14:00:38 -0400
In-Reply-To: <46B5FA39.5050907@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>, linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>, Mark Hindley <mark@hindley.org.uk>

Michal Piotrowski wrote:
> Virtualization
>
> Subject         : drivers/net/xen-netfront.c: bogus code
> References      : http://lkml.org/lkml/2007/7/22/256
> Last known good : ?
> Submitter       : Adrian Bunk <bunk@stusta.de>
> Caused-By       : ?
> Handled-By      : Jeremy Fitzhardinge <jeremy@goop.org>
> Status          : unknown
>   

This is just a chunk of dead code.  It probably doesn't even affect the
generated code.  I've got a patch here for it, and I'll probably post it
in the next day or so, but this seems like a non-issue.

    J
