From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [multipath] SCSI device capacity mess
Date: 26 Oct 2004 17:34:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098826481.2140.534.camel@mulgrave>
References: <1098833278.4914.24.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:58306 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261494AbUJZVev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 17:34:51 -0400
In-Reply-To: <1098833278.4914.24.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2004-10-26 at 19:27, christophe varoqui wrote:
> 1) make the /sys/block/*/size attribute writable
> 2) resurrect a BLKSETSIZE ioctl
> 3) make device-mapper less strict, and hope we can fix the size by a
> device rescan when it get activated
> 4) sell the culprit hardware

Only 3 & 4 look viable.  There's little point introducing an extra API
or ioctl specifically to defeat a check, since the check will now be
useless anyway.

The "random" value is 1GB by the way.  Since the dawn of time SCSI has
reported this for devices that failed read capacity.

James



