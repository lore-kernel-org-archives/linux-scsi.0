From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 07:16:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028071637.B8503@beaverton.ibm.com>
References: <1067313069.1277.17.camel@ronald.kuetemeier.com> <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:25751 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263994AbTJ1PRd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 10:17:33 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Tue, Oct 28, 2003 at 10:03:06AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ronald Kuetemeier <ronald@kuetemeier.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, Oct 28, 2003 at 10:03:06AM -0500, Alan Stern wrote:

> It's not clear to me what is the best way to take care of the devices that 
> choke on page 3F.  Should we use a special flag for those devices or 
> should we disable it entirely?

I don't know, good question.

And more generally, should we add devices to the scsi_devinfo.c blacklist,
and only use the dynamic addition to the black list until the new code is
available?

I am still looking at the logs - I don't see any logging of the actual
failure, and I did not see a failure immediately after the 3f was sent.

We should first try and get his device working without black listing it.

-- Patrick Mansfield
