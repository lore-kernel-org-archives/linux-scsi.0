From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2] usb/uas: one only one status URB/host on
 stream-less connection
Date: Fri, 23 Dec 2011 10:46:02 +0100
Message-ID: <20111223094602.GA11117@linutronix.de>
References: <20111220150126.GA29286@linutronix.de>
 <Pine.LNX.4.44L0.1112201035240.1690-100000@iolanthe.rowland.org>
 <20111220171621.GC29286@linutronix.de>
 <20111221192543.GA15279@xanatos>
 <20111222141525.GA19406@linutronix.de>
 <20111223010720.GD18989@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37181 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab1LWJqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2011 04:46:06 -0500
Content-Disposition: inline
In-Reply-To: <20111223010720.GD18989@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

* Sarah Sharp | 2011-12-22 17:07:20 [-0800]:

>
>Great!  I'll pull from that and start building on top of it.  Honestly
>though, I won't have time for this until after the holidays.  I can ask
>Greg to pull these as-is for 3.3 if you're really antsy to get them out.

It is up to you. I have fixes which will make upstream and this is good
enough for me. I had a USB3.0 HD the other day but it did not support
UAS it as talking the old protocol. So I guess most users won't be bit
by this right now.

>Sarah Sharp

Sebastian
