From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] st implement tape statistics v3
Date: Mon, 9 Feb 2015 16:14:59 +0800
Message-ID: <20150209081459.GB8989@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3F33B@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664AbbBIIPD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2015 03:15:03 -0500
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3F33B@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>

On Mon, Feb 09, 2015 at 06:01:39AM +0000, Seymour, Shane M wrote:
> Hi All,
> 
> Please find attached v3 of the patch. It implements the changes requested by Greg. The statistics files aren't in a separate directory any more they're implemented directly as device attributes unless someone has objections to them being in a place like /sys/class/scsi_tape/*/.

Why not keep them in a subdir, like before?  You can still do that with
a sysfs attribute group, just make a new one and add it to the existing
list of groups for the tape device.  Makes things a bit more "simple"
for userspace, they can just iterate over all of the files in the
directory, instead of having to only open some of them.

thanks,

greg k-h
