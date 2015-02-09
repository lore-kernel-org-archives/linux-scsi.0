From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] st implement tape statistics v3
Date: Tue, 10 Feb 2015 07:03:39 +0800
Message-ID: <20150209230339.GA14070@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3F611@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbbBIXDo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2015 18:03:44 -0500
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3F611@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>

Comment about your subject: the "v3" needs to go inside the []

And you need to put below the --- line what has changed from the last
version, I don't see any of my comments address here :(

On Mon, Feb 09, 2015 at 10:41:38PM +0000, Seymour, Shane M wrote:
> The following patch exposes statistics for the st driver via sysfs. There is a need for companies with large numbers of tape drives numbering in the tens of thousands to track the performance of those tape drives (e.g. when a backup exceeds its window). The statistics provided should allow the calculation of throughput, average block sizes for read and write, and time spent waiting for I/O to complete or doing tape movement.

Your keyboard has an "Enter" key, please use it around the 72nd column :)

thanks,

greg k-h
