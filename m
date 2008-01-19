From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL
Date: Sat, 19 Jan 2008 08:59:05 +0100
Message-ID: <4791ADC9.7090207@s5r6.in-berlin.de>
References: <478F8435.5000907@panasas.com> <478F854B.2030302@panasas.com> <478F9596.1020509@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40206 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYASH7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jan 2008 02:59:11 -0500
In-Reply-To: <478F9596.1020509@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Stefan Richter wrote:
> My guess is that there won't be conflicts of this with linux1394-2.6.git
> anytime soon, so taking it into any other tree should be fine.

Wrong, there should already be a (trivial) conflict due to a patch from
December.  Another (trivially) conflicting patch was sent to
linux1394-devel a few hours ago.  Both patches will land in Linus' tree
early during the next merge window.  So either refresh the patch when
it's time, or give it to me.  (Whatever, try not to add to akpm's pain.)
-- 
Stefan Richter
-=====-==--- ---= =--==
http://arcgraph.de/sr/
