From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: 27 Oct 2004 17:57:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098914250.1588.1.camel@mulgrave>
References: <1098833278.4914.24.camel@zezette>
	<20041027081713.GC32712@marowsky-bree.de>
	<1098903759.12464.32.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1726 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262957AbUJ0V5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 17:57:45 -0400
In-Reply-To: <1098903759.12464.32.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2004-10-27 at 15:02, christophe varoqui wrote:
> I wonder if it's not simpler just to remove the NOSTARTONADD flag on
> this devices in scsi_devinfo.c. I tested that and all the READ CAPACITY
> succeed as expected (DEC HSG80 / COMPAQ HSV*).
> 
> Wasn't this flag in part motivated by the lack of multipath support
> anyway ?
> 
> Even in a cluster context, I don't really buy the annoyance of
> occasional LUN ping-pong.

It's not occasional, it happens every time a single machine in the
cluster reboots and the HSG80 can take a while to transfer luns. 
Configure one with several hundred luns in a 32 node cluster and you'll
see why this flag exists...

James


