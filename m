From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Full hostlock pushdown available
Date: Sun, 31 Oct 2010 19:48:21 +0100 (CET)
Message-ID: <tkrat.c4793af298337eff@s5r6.in-berlin.de>
References: <20101028150508.GA2385@basil.fritz.box>
 <4CCD5F7F.8020808@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34477 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab0JaStt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2010 14:49:49 -0400
In-Reply-To: <4CCD5F7F.8020808@panasas.com>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

> On 10/28/2010 05:05 PM, Andi Kleen wrote:
>> The following changes since commit 39764981e772adc832d8a96e6540be346a830ca2:
>> 
>>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6 (2010-10-27 20:54:34 +0200)
>> 
>> are available in the git repository at:
>> 
>>   ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git hostlock

Don't forget this one:

--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1087,8 +1087,7 @@ Details:
  *      non-zero return, it must not execute the command's done
  *      callback at any time.
  *
- *      Locks: struct Scsi_Host::host_lock held on entry (with "irqsave")
- *             and is expected to be held on return.
+ *      Locks: none
  *
  *      Calling context: in interrupt (soft irq) or process context
  *

-- 
Stefan Richter
-=====-==-=- =-=- =====
http://arcgraph.de/sr/

