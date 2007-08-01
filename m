From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: regression: panic from qlogic driver in qla2x00_read_nvram_data
Date: Wed, 1 Aug 2007 13:48:19 -0600
Message-ID: <20070801194819.GD21219@parisc-linux.org>
References: <1185997129.9592.39.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39803 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbXHATsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 15:48:20 -0400
Content-Disposition: inline
In-Reply-To: <1185997129.9592.39.camel@deimos.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Chapman <doug.chapman@hp.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 01, 2007 at 03:38:49PM -0400, Doug Chapman wrote:
> I am seeing a panic on the latest git trees on my ia64 servers with
> qlogic cards installed.  The latest this was known to work OK was
> v2.6.23-rc1.  I am currently working on a git bisect to narrow down what
> introduced this but due to other unrelated problems that is not going
> smoothly.  Let me know if there is other info I can provide that would
> be helpful.

Already known and fixed ...

http://marc.info/?l=linux-scsi&m=118581884800073&w=2

BTW, you don't have to git-bisect, you can find suspicious looking
commits and git-revert them.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
