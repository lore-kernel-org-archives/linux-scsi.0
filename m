From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: [PATCH] Format Unit can take many hours
Date: Tue, 11 May 2004 12:44:56 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405111243300.14297-100000@sweetums.bluetronic.net>
References: <20040511162822.C46BFDBDB@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:57249 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S264888AbUEKQti (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2004 12:49:38 -0400
In-Reply-To: <20040511162822.C46BFDBDB@gherkin.frus.com>
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>

On Tue, 11 May 2004, Bob Tracy wrote:
>Moreover, it simply "feels" wrong to define a constant for something
>that isn't...  The quick fix of increasing the timeout doesn't address
>the underlying issue of how long a format should take, and as Ricky
>implies, that's probably more the concern of the application rather
>than the driver.

The real problem is a lack of being able to specify a timeout for user
supplied commands.  In-kernel drivers can set a command timeout.  The
IOCTL interface does not export that capability.

--Ricky


