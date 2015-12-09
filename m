From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 14:14:59 +0000
Message-ID: <20151209141459.41a237c9@lxorguk.ukuu.org.uk>
References: <55B9CA3B.1030205@suse.de>
	<20151209102453.GE3173@mwanda>
	<20151209115339.46a09d94@lxorguk.ukuu.org.uk>
	<20151209134512.GA5177@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42373 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbLIOPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 09:15:23 -0500
In-Reply-To: <20151209134512.GA5177@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Ondrej Zary <linux@rainbow-software.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, 9 Dec 2015 16:45:12 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Everyone knows I didn't test it but it's an obvious one line fix for
> memory corruption.  If no one uses the code, at least this is harmless
> and silences a static checker warning.
> 
> In olden times we used to say, "Oh this bounds checking is crap but it's
> root only so let's leave it alone."  But these days we just fix it.
> It's easier to just fix everything instead of trying to decide which
> bugs are critical.

Unfortunately it's all too easy to look down 50 commit messages to an
apaprently active file all "fixing small bugs" or "correcting indenting"
without realising that every single one of them should have been tagged

"[UNTESTED]: "

so that anyone looking at the code can see immediately its historical
hazardous waste.

Alan
