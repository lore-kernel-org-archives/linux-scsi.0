From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to
	detect arrays
Date: Fri, 18 Aug 2006 16:18:58 -0700
Message-ID: <1155943138.3766.9.camel@mulgrave.il.steeleye.com>
References: <200608180959.16889.joshua@rubixlinux.org>
	 <20060818163904.GC16593@athena.road.mcmartin.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:39372 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751582AbWHRXVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 19:21:05 -0400
In-Reply-To: <20060818163904.GC16593@athena.road.mcmartin.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle McMartin <kyle@parisc-linux.org>
Cc: Joshua Rubin <joshua@rubixlinux.org>, 380272@bugs.debian.org, maximilian attems <maks@sternwelten.at>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Fri, 2006-08-18 at 12:39 -0400, Kyle McMartin wrote:
> The problem is because they both claim support for the same PCI Ids:

That's this fix, isn't it?

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=b2b3c121076961333977f485f0d54c22121df920

James


