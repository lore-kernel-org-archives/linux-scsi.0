From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [linux-iscsi-devel] [question] deferred sense
Date: Thu, 06 Jan 2005 10:50:27 -0500
Message-ID: <1105026628.4319.32.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B9B96C3@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59610 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262866AbVAFPuf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 10:50:35 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B9B96C3@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-01-06 at 09:57 -0500, Salyzyn, Mark wrote:
> The key to higher performance is a cluster solution that permits cache
> on, and in doing so, the issues of deferred failure is similar. I am not
> talking pie in the sky here; there are proprietary solutions (from low
> end all the way up to the `world scale cache' of the Yotta-Yotta's of
> the world)

HA is about safety first and then performance.  Something with a local
writeback cache is always HA unsafe and thus it won't be supported by
the major HA vendors.

> The point is deferred failure is not the only user of these changes to
> the file-system layer. In the low end, this kind of technology is being
> added to Windoze and has been part of Netware (including complete system
> memory synchronization between failover machines) for years; there are
> customers of redundant solutions that require this.
> 
> In the Public Domain, simplicity usually drives adoption (just measure
> the pain Sistina had asking for a new atomic SCSI command). I am not
> sure the General Purpose customer wants to 'pay' for unused complexity
> and the accompanying doubt of stability ...

I'll agree but only if you can't achieve the desired end by simple
means.  In this case, you can, you set the cache to writethrough and the
problem goes away.

James


