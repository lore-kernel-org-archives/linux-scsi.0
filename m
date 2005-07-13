From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Thu, 14 Jul 2005 00:39:32 +0200
Message-ID: <42D59824.9070404__34071.8471249149$1121320882$gmane$org@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>	 <20050710033431.GB13883@havoc.gtf.org>	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>	 <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave>	 <42D18171.8050207@s5r6.in-berlin.de>	 <20050710202734.GI14956@phunnypharm.org>	 <42D191F7.8030506@s5r6.in-berlin.de> <42D19BF8.9080507@s5r6.in-berlin.de>	 <42D1A1EF.1060006@s5r6.in-berlin.de> <1121090241.5045.3.camel@mulgrave>	 <42D571F3.1070105@s5r6.in-berlin.de> <1121285524.5049.53.camel@mulgrave> <42D582EF.3060701@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54434 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S262341AbVGMWjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 18:39:47 -0400
In-Reply-To: <42D582EF.3060701@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>

I wrote:
> I'll try to get some more info.

There is no way to get more than I already posted. (Except maybe
with a serial console.) All other atempts ended at the first inquiry
command or even at sbp2's "Logged into SBP-2 device" message, leaving
the following SCSI commands to our imagination. Why does the kernel
reboot anyway? If it at least only halted, then I could watch klogd
at the virtual console.

However. The bug is probably in the handling of MODE_SENSE_10 responses
because this is how the new sbp2 code differs from the old code WRT
TYPE_DISK devices as far as I can see. The AVLAB enclosure's firmware
perhaps returns something like a TYPE_RBC device despite it claims to be
of TYPE_DISK.
-- 
Stefan Richter
-=====-=-=-= -=== -===-
http://arcgraph.de/sr/
