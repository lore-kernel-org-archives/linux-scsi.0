From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: oops in kernel 2.6.9
Date: 20 Oct 2004 08:32:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098279164.2002.7.camel@mulgrave>
References: <20041019175146.15889e11.akpm@osdl.org>
	<20041020064255.GB8755@suse.de>  <20041019234857.7ddf5bc7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49337 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270009AbUJTNc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 09:32:57 -0400
In-Reply-To: <20041019234857.7ddf5bc7.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Jens Axboe <axboe@suse.de>, nickpiggin@yahoo.com.au, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-20 at 01:48, Andrew Morton wrote:
> Jens Axboe <axboe@suse.de> wrote:
> >
> > On Tue, Oct 19 2004, Andrew Morton wrote:
> > > 
> > > oy.
> > 
> > Looks like a SCSI issue, it probably killed the queue before the io
> > scheduler was entered again.
> 
> Better add linux-scsi to cc then...

The SCSI half of the fix for this is in bk latest (that was adding a
refcount to the device as soon as the command is issued).  I'm not sure
about the usb-storage piece (not exciting the error handler by ignoring
commands when the device is unplugged).

James


