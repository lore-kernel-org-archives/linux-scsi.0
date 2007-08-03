From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Fri, 03 Aug 2007 21:37:02 +0200
Message-ID: <46B383DE.9060408@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <200708022112.16298.rob@landley.net> <46B2E41F.7090705@s5r6.in-berlin.de> <200708031407.31175.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48472 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXHCTh0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 15:37:26 -0400
In-Reply-To: <200708031407.31175.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Rob Landley wrote:
> They keep using the fact that they're exporting random kernel data as an 
> excuse for not documenting a stable subset of this as an API userspace can 
> rely on.

At least sysfs-rules.txt is a start, although it contains more Don'ts
than Dos.

...
> This is a bug, not a feature.  Linux has always had a 
> stable _USERSPACE_ API.  This is exposed to userspace, and userspace is 
> expected to be able to use this.  If they're exporting stuff they shouldn't 
> be exporting, then they should stop exporting it.

The kernel log is exported to userspace too.

(Ugh, there were actually suggestions to make the log stable too, e.g.
to tack stable unique identifiers to log messages...)
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
