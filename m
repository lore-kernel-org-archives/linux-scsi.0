From: Jens Axboe <axboe@suse.de>
Subject: Re: queue <-> sdev reference counting problem
Date: Mon, 21 Mar 2005 16:54:15 +0100
Message-ID: <20050321155414.GI25452@suse.de>
References: <20050318113609.GC1821@suse.de> <20050321145900.GH25452@suse.de> <1111419828.5504.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:2963 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261842AbVCUPyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 10:54:19 -0500
Content-Disposition: inline
In-Reply-To: <1111419828.5504.11.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Mar 21 2005, James Bottomley wrote:
> On Mon, 2005-03-21 at 15:59 +0100, Jens Axboe wrote:
> > This is not even enough, since the queue lock is embedded in sdev
> > structure. Guys, this is a serious issue. Oopsing a kernel is trivial
> > with a hotplug device like a usb stick.
> 
> Do you have the instructions to reproduce and a trace ... I've got a USB
> pendrive I can try with.

Let a little app open/close the device, run that. Then remove and
reinsert the device, boom.

-- 
Jens Axboe

