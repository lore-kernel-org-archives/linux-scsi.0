From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Potential out-of-bounds access in drivers/scsi/sd.c
Date: Wed, 4 Sep 2013 11:42:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309041142090.1186-100000@iolanthe.rowland.org>
References: <CACT4Y+Zose3b8xrmwYbpNfPAqiJtuS9w3Y61==kaOd_LHK6uMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51460 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934868Ab3IDPmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2013 11:42:38 -0400
In-Reply-To: <CACT4Y+Zose3b8xrmwYbpNfPAqiJtuS9w3Y61==kaOd_LHK6uMg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, richard <richard@r-senior.demon.co.uk>, ltuikov <ltuikov@yahoo.com>, jbottomley <jbottomley@parallels.com>, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

On Wed, 4 Sep 2013, Dmitry Vyukov wrote:

> Thanks, Alan!
> 
> I agree with Paolo that the branch can be removed.
> 
> Will you take care of landing the patch?

I will when everyone agrees it is ready.

Alan Stern

