From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: dc395 with a scanner, failing.
Date: Thu, 3 Jun 2004 19:08:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040603090849.GA6148@twibble.org>
References: <40B4CA83.8020700@nosomos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([202.173.155.197]:65241 "EHLO
	tuon.twibble.org") by vger.kernel.org with ESMTP id S261932AbUFCJIx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2004 05:08:53 -0400
Content-Disposition: inline
In-Reply-To: <40B4CA83.8020700@nosomos.org>
List-Id: linux-scsi@vger.kernel.org
To: Quercus <quercus@nosomos.org>
Cc: linux-scsi@vger.kernel.org

On Wed, May 26, 2004 at 06:49:07PM +0200, Quercus wrote:
> Hi there... I own a dc395 scsi card "working" on a Debian GNU/Linux 3.0, 
> with kernels 2.4.22 and 2.6.5.

So it works fine in 2.6.5 and not 2.6.6? I'll have to look at what
other changes went in between those versions.

[...]
> What other tests should I do to send some feedback to the list and try 
> to find a solution? Anyone had this same problem?

Edit the top of drivers/scsi/dc395x.c and uncomment the first
"#define DEBUG_MASK" line, rebuild the dc395x module, reload the
module and then the operation that failes again. You should then gets
lots of debugging output in one of your log file which you can then
gzip or bzip2 and then send directly to me and I'll take a look at
it.

Thanks.
Jamie.

-- 
 Jamie Lenehan <lenehan@twibble.org>
