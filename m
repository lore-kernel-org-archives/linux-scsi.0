From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 11 Nov 2003 16:52:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068594777.6448.7.camel@patrh9>
References: <1068165515.28505.29.camel@patrh9>
	 <20031107095145.A3785@beaverton.ibm.com>  <1068228695.3417.34.camel@patrh9>
	 <1068229639.3417.46.camel@patrh9>  <1068229873.3417.51.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:10394 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263849AbTKKXx1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 18:53:27 -0500
In-Reply-To: <1068229873.3417.51.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

The SG_IO analogue in BSD may be:

http://www.google.com/search?q=man+SCIOCCOMMAND

The corresponding struct appears in such sources as:

http://cvsup.pt.freebsd.org/cgi-bin/cvsweb/cvsweb.cgi/src/sys/sys/scsiio.h?rev=1.9.4.2&content-type=text/x-cvsweb-markup&cvsroot=NetBSD

Same as ever, again there we see CDB for length, data for expected
length returning actual length, sense for expected length returning
actual length.

Pat LaVarre


