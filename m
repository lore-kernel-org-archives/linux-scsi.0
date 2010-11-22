From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Mon, 22 Nov 2010 09:07:51 -0800
Message-ID: <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com>
References: <949636.86471.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab0KVRId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 12:08:33 -0500
In-Reply-To: <949636.86471.qm@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>

On Mon, Nov 22, 2010 at 8:56 AM, Luben Tuikov <ltuikov@yahoo.com> wrote:
>
> Some kernel transport drivers unconditionally disable
> retrieval of the Caching mode page. One such for example is
> the BBB/CBI transport over USB.

One reason for that is that historically we've seen devices that
simply go crazy - to the point of simply stopping to respond to
anything - when you ask for pages that Windows doesn't ask for.

It's especially common on USB storage, but it happens elsewhere too.
The device firmware simply hasn't ever been tested in that situation,
and it's buggy.

So I don't mind the patch per se, but I think it's potentially way
more dangerous than it looks.

                    Linus
