From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: [Bugme-new] [Bug 5998] New: oops on mount "kernel access
 of bad area, sig: 11 [#1]"
Date: Fri, 03 Feb 2006 08:43:12 +0100
Message-ID: <43E30990.9070901@s5r6.in-berlin.de>
References: <20060202150719.0dafc8ae.akpm@osdl.org> <43E306AC.60004@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:17039 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932500AbWBCHq0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 02:46:26 -0500
In-Reply-To: <43E306AC.60004@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: johnstul@us.ibm.com, Andrew Morton <akpm@osdl.org>, linux1394-devel@lists.sourceforge.net

I wrote:
> Perhaps one or the other or both places in sbp2 need to take the
> Scsi_Host's host_lock.

...well, or rather not, as far as I am now recalling of what host_lock 
actually protected the last time I checked...
-- 
Stefan Richter
-=====-=-==- --=- ---==
http://arcgraph.de/sr/
