From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Thu, 24 Nov 2005 05:28:03 -0700
Message-ID: <20051124122803.GZ1598@parisc-linux.org>
References: <20051123134327.GS1598@parisc-linux.org> <20051123143508.GT1598@parisc-linux.org> <200511240013.17352.jsanchez@todounix.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:61062 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1030383AbVKXM2H
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Nov 2005 07:28:07 -0500
Content-Disposition: inline
In-Reply-To: <200511240013.17352.jsanchez@todounix.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jos? Luis S?nchez <jsanchez@todounix.homeip.net>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 24, 2005 at 12:13:17AM +0100, Jos? Luis S?nchez wrote:
> Well, I have probed the Linux kernels from 2.6.11 to 2.6.14, without using the 
> NVidia display driver, only DRM and agpgart drivers. The problem appears at 
> 2.6.14, from 2.6.11 to 2.6.13 all works well. Now, I guess what is a problem 
> related to the SCSI layer and not to the sym53c8xx_2 driver (2.6.14 don't 
> have any patch to the sym2 driver).

Hm.  Well, that makes me feel better.  I'd still like to find out why
your tape drive is only negotiating 20MB/s rather than the 40MB/s it
negotiates under Solaris though.  Did you try setting it to wide?
