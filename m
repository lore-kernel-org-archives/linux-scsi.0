From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL
Date: Sat, 19 Jan 2008 16:16:38 +0100
Message-ID: <47921456.3060803@s5r6.in-berlin.de>
References: <478F8435.5000907@panasas.com> <478F854B.2030302@panasas.com>	 <478F9596.1020509@s5r6.in-berlin.de>  <4791ADC9.7090207@s5r6.in-berlin.de> <1200754905.3136.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55168 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYASPSA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jan 2008 10:18:00 -0500
In-Reply-To: <1200754905.3136.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Actually, I'm already tracking potential conflicts.  The
> linux1394-2.6.git is part of the merge candidate tree I'm building
> nightly.

Right, I saw your announcement of this tree.

> These patches will go through the (now slightly misnamed)
> scsi-bidi-2.6.git tree.  That one's built on top of all the currently
> conflicting trees, and is scheduled to be the last thing merged in the
> merge window (or at least to wait until the others its built on have
> gone in).

Good, everything should come together nicely then.
-- 
Stefan Richter
-=====-==--- ---= =--==
http://arcgraph.de/sr/
