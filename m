From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 21:22:57 +0200
Message-ID: <433C3F11.3050408@s5r6.in-berlin.de>
References: <43384E28.8030207@adaptec.com> <4339BFE9.1060604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:25571 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932375AbVI2TXc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 15:23:32 -0400
In-Reply-To: <4339BFE9.1060604@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <luben_tuikov@adaptec.com>

Jeff Garzik wrote:
> * Avoids (rather than fix) several SCSI core false dependencies on HCIL. 

BTW, other SCSI transport layers in Linux do this too, and have been 
doing so for some time. So this is hardly a valid reason not to include 
the new SAS layer.
-- 
Stefan Richter
-=====-=-=-= =--= ===-=
http://arcgraph.de/sr/
