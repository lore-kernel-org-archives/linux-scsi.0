From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: queue <-> sdev reference counting problem
Date: Mon, 21 Mar 2005 09:43:48 -0600
Message-ID: <1111419828.5504.11.camel@mulgrave>
References: <20050318113609.GC1821@suse.de> <20050321145900.GH25452@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:1224 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261824AbVCUPnv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 10:43:51 -0500
In-Reply-To: <20050321145900.GH25452@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-03-21 at 15:59 +0100, Jens Axboe wrote:
> This is not even enough, since the queue lock is embedded in sdev
> structure. Guys, this is a serious issue. Oopsing a kernel is trivial
> with a hotplug device like a usb stick.

Do you have the instructions to reproduce and a trace ... I've got a USB
pendrive I can try with.

James


