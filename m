From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: Re: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Mon, 5 Apr 2004 01:20:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404050120.56111.andrex@alumni.utexas.net>
References: <20040327161034.GA9963@twibble.org> <200403271759.08361.andrex@alumni.utexas.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:33012 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S261426AbUDEFU5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 01:20:57 -0400
In-Reply-To: <200403271759.08361.andrex@alumni.utexas.net>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

> First thing to try would be to upgrade to 2.6.5-rc1 (or newer) and
> see if that works any better.

I'm now running kernel 2.6.5.  The good news is that my CD writer (HP 9200i) 
works again.  The bad news is that I'm still getting e.g.

Apr  5 00:46:50 helium kernel: dc395x: sg_update_list: sg_to_virt failed
Apr  5 00:47:21 helium last message repeated 576 times
Apr  5 00:48:22 helium last message repeated 974 times
Apr  5 00:49:23 helium last message repeated 979 times
Apr  5 00:50:24 helium last message repeated 971 times
Apr  5 00:51:25 helium last message repeated 970 times
Apr  5 00:52:26 helium last message repeated 974 times
Apr  5 00:52:40 helium last message repeated 228 times

(result of burning a CD).  This isn't great, but it's tolerable and at least 
the CD writer works again.

Andrew.
