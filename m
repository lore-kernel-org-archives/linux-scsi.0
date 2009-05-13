From: Greg KH <greg@kroah.com>
Subject: Re: Query to optimize PageCache size in system
Date: Wed, 13 May 2009 08:43:45 -0700
Message-ID: <20090513154345.GA961@kroah.com>
References: <e42309110905130732xf4313a6qba1f30a2d89728be@mail.gmail.com> <e42309110905130805r135c3373xa6ecda0e45180d34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54962 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZEMPrG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 11:47:06 -0400
Content-Disposition: inline
In-Reply-To: <e42309110905130805r135c3373xa6ecda0e45180d34@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravish Tayal <ravish.tayal@gmail.com>
Cc: linux-arm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-usb@vger.kernel.org, ravish.tayal@conexant.com

On Wed, May 13, 2009 at 08:35:52PM +0530, Ravish Tayal wrote:
> Hi
> I am looking for help to reduce the number of cached pages in the
> system. I am using 2.6.12 linux kernel on ARM processor.for my
> embedded USB mass storage application.

Hm, 2.6.12 was released almost 4 years ago.  A few hundred thousand
kernel changes have happened since then, and we really can't do much
about such old kernel releases.

If you can still see the same issues in a more modern kernel release, we
will be glad to help out.  Might I suggest 2.6.29?

Best of luck,

greg k-h
