From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 26 Jun 2007 11:38:31 +0200
Message-ID: <4680DE97.2010207@s5r6.in-berlin.de>
References: <748779.88428.qm@web31804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:46982 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbXFZJii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 05:38:38 -0400
In-Reply-To: <748779.88428.qm@web31804.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Display this:
>  "%016llx", ((unsigned long long) be64_to_cpu(*(__be64 *)(LUN))),
> where LUN is u8[8].  Notice the ugly, C-centric "0x" prefix
> is missing.

I agree.  We don't need 0x prefix nor h suffix nor delimiters like
spaces, dashes, colons... in the kernel's printouts of LUNs (i.e. in
sysfs attribute values or sysfs path components or dmesg debug printouts
or wherever the kernel might hand out LUN represemtations to userspace).

...
> This also makes it great to be a directory name, since it is the
> same width and format,
...

Yes, that's quite OK for syfs path components.  But remember that syfs
path components are considered unstable sysfs ABI elements.
-- 
Stefan Richter
-=====-=-=== -==- ==-=-
http://arcgraph.de/sr/
