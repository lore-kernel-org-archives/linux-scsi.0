From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Unplugging of SBP-2 devices still does not work
Date: Sun, 31 Jul 2005 22:17:02 +0200
Message-ID: <42ED31BE.2090803@s5r6.in-berlin.de>
References: <42E29DF5.5090603@s5r6.in-berlin.de> <42E2A15A.2030609@s5r6.in-berlin.de> <20050726042640.GA17885@phunnypharm.org> <42EBF6A2.7040305@s5r6.in-berlin.de> <42EC0A1D.1090008@s5r6.in-berlin.de> <20050731173554.GA2970@us.ibm.com> <42ED1CE5.9080903@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37589 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261989AbVGaUTP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 16:19:15 -0400
In-Reply-To: <42ED1CE5.9080903@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Patrick Mansfield <patmans@us.ibm.com>

> Patrick Mansfield wrote:
>> device_for_each_child is not "safe", see this thread:
>> http://marc.theaimsgroup.com/?t=111931541100002&r=1&w=2
...
>> I think DEBUG_SLAB will catch any use after frees there.
...

I tested with CONFIG_DEBUG_SLAB now. Nothing showed up.
-- 
Stefan Richter
-=====-=-=-= -=== =====
http://arcgraph.de/sr/
