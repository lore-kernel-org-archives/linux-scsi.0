From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [BUG] 2.6.9-rc2 scsi and elevator oops
 when I/O error
Date: Mon, 11 Oct 2004 15:07:51 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410111506250.21084-100000@netrider.rowland.org>
References: <1097503418.2031.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2835 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S269175AbUJKTHw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 15:07:52 -0400
In-Reply-To: <1097503418.2031.14.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>, Pedro Larroy <piotr@larroy.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On 11 Oct 2004, James Bottomley wrote:

> On Mon, 2004-10-11 at 04:50, Jens Axboe wrote:
> > It's not, it clearly looks like SCSI trying to kill off the queue
> > with pending commands.
> 
> That's what it looks like to me too ... there should be a fix for this
> in the scsi-misc-2.6 tree.

There also was a fix for usb-storage just submitted for the gregkh-2.6 
tree:

http://marc.theaimsgroup.com/?l=linux-usb-devel&m=109744234829347&w=2

It should help prevent the condition that triggers this situation.

Alan Stern

