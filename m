From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Thu, 19 Oct 2006 05:23:05 -0700
Message-ID: <1161260585.3204.33.camel@home-desk>
References: <1161210246.3204.17.camel@home-desk>
	 <1161210748.3204.22.camel@home-desk>  <1161237121.15090.9.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:39352 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1423328AbWJSMXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 08:23:08 -0400
In-Reply-To: <1161237121.15090.9.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org


> Does this only occur with sg or is that the only way you got a trace? In
> the original bug report you mentioned it occurring with mkfs, but the
> bug oops is from a sg request. Is tdg_2 run while the mkfs is running?

In my case, the issue exists with or without sg.

In my example with mkfs, it may or may not dump a trace.  The mkfs may
just take 'forever' and not really do anything.  Thankfully, the sg
module was causing a dump.  Hope this helps.

I'll try to get a SCSI BUS trace this Morning.

Sean

