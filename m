From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BUG] 2.6.9-rc2 scsi and elevator oops when I/O error
Date: 11 Oct 2004 09:03:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097503418.2031.14.camel@mulgrave>
References: <20041011050320.GA28703@larroy.com>
	<416A3FF2.3000206@yahoo.com.au>  <20041011095035.GE2290@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:17060 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268980AbUJKODt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 10:03:49 -0400
In-Reply-To: <20041011095035.GE2290@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Pedro Larroy <piotr@larroy.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Mon, 2004-10-11 at 04:50, Jens Axboe wrote:
> It's not, it clearly looks like SCSI trying to kill off the queue
> with pending commands.

That's what it looks like to me too ... there should be a fix for this
in the scsi-misc-2.6 tree.

James


