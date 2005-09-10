From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Sat, 10 Sep 2005 19:35:57 +0200
Message-ID: <4323197D.7070401@s5r6.in-berlin.de>
References: <1126212613.7479.20.camel@markh1.pdx.osdl.net> <1126370295.4813.49.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:9959 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932093AbVIJRg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 13:36:29 -0400
In-Reply-To: <1126370295.4813.49.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mark Haverkamp <markh@osdl.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Ben Collins <bcollins@debian.org>

James Bottomley wrote:
> scsi_add_device() returns an sdev on
> success with the refcount bumped up for you.  If you don't do a put,
> you'll be stuck with a device you can't get rid of.
> 
> However, all other users of scsi_add_device() make the same mistake ...

Sbp2 was fixed recently, thanks to your advice. (Although the fix did 
not make it into Linus' tree yet.)

> I'll apply this patch and fix the API to return zero or error and not
> bump the sdev refcount.

If you will do this, the now correct scsi_device_put() will become not 
only incorrect but even dangerous, won't it?
-- 
Stefan Richter
-=====-=-=-= =--= -=-=-
http://arcgraph.de/sr/
