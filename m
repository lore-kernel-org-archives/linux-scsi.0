From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [linux-iscsi-devel] [question] deferred sense
Date: Thu, 6 Jan 2005 09:57:05 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B9B96C3@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33001 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262849AbVAFO5I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 09:57:08 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley sez: 
> If you're thinking of having a writeback
> cache in a raid card on a host, then you'll find all the documentation
> for clustering will explicitly warn you to switch it to write through
(I
> know ours does).

The key to higher performance is a cluster solution that permits cache
on, and in doing so, the issues of deferred failure is similar. I am not
talking pie in the sky here; there are proprietary solutions (from low
end all the way up to the `world scale cache' of the Yotta-Yotta's of
the world)

The point is deferred failure is not the only user of these changes to
the file-system layer. In the low end, this kind of technology is being
added to Windoze and has been part of Netware (including complete system
memory synchronization between failover machines) for years; there are
customers of redundant solutions that require this.

In the Public Domain, simplicity usually drives adoption (just measure
the pain Sistina had asking for a new atomic SCSI command). I am not
sure the General Purpose customer wants to 'pay' for unused complexity
and the accompanying doubt of stability ...

Sincerely -- Mark Salyzyn
