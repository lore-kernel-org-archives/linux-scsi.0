From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: OOPS: unplugging western digital passport drive
Date: Wed, 18 Mar 2015 10:22:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1503181013070.1497-100000@iolanthe.rowland.org>
References: <5508D6B0.3010806@stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50713 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933931AbbCROW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2015 10:22:29 -0400
In-Reply-To: <5508D6B0.3010806@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: =?UTF-8?B?U3RhbmlzxYJhdyBQaXR1Y2hh?= <viraptor@gmail.com>, linux-scsi@vger.kernel.org

On Tue, 17 Mar 2015, Joe Lawrence wrote:

> On 03/11/2015 12:25 AM, Stanis=C5=82aw Pitucha wrote:
> > Hi linux-scsi,
> > I've got another case of reproducible crash when unplugging western
> > digital passport drives. This was mentioned before in
> > http://www.spinics.net/lists/linux-scsi/msg82603.html

Like it says in that thread, the problem is somehow related to the ses
driver.  If you remove or blacklist that driver, there won't be any
more crashes.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
