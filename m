From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: [BK-PATCH] 3w-9xxx: proc interface
Date: Fri, 2 Jul 2004 14:42:14 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0407021430120.25702-100000@sweetums.bluetronic.net>
References: <20040702183506.GA30810@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:51419 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S264795AbUGBSsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2004 14:48:39 -0400
In-Reply-To: <20040702183506.GA30810@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Adam Radford <aradford@amcc.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Fri, 2 Jul 2004, Christoph Hellwig wrote:
>On Fri, Jul 02, 2004 at 12:08:23PM -0400, Ricky Beam wrote:
>> 3dm2 (the currently available one anyway) needs /proc/scsi/3w-9xxx to
>> discover any controllers.  The current in-kernel driver doesn't contain any
>> /proc/scsi support.  The attached patch restores the interface.
>
>I'd rather wait for a new 3dm2 release instead of adding deprecated interfaces.
>Adam, any schedule for a new release?

Well, I'm not the only one who cannot monitor/control their array with the
current in-kernel driver.  I don't care if the proc interface makes it
back into the kernel; the systems I assemble with a 9500 will have the
proc interface restored until I have a 3dm2 in hand that doesn't need it.

Having a non-functioning 3dm2 is a major problem in my book. (technically,
not have a firmware update interface in the kernel's driver is also a
concern.)

Locking the door before you have a key to get back in is a bad idea.

--Ricky


