From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: aacraid adapter kernel panic'd ffffffff on 2.6.37 but not 2.6.32
Date: Tue, 5 Apr 2011 13:13:41 -0400
Message-ID: <20110405171341.GB351@caffeine.csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49292 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab1DERNl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2011 13:13:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: aacraid@adaptec.com, Len Sorensen <lsorense@csclub.uwaterloo.ca>, linux-scsi@vger.kernel.org

I have an IBM serveraid 8k which is currently running a 2.6.32 kernel.
I tried booting knoppix 6.4.4 which uses a 2.6.37 kernel to do some disk
rearanging and was rather surprised that the aacraid failed to come up
and instead resulting in the message:

AAC0: adapter kernel panic'd ffffffff
(transcribed by hand from memory, but I am pretty sure they were all f's).

The firmware version on the adapter is 5.2-0[16002].

It is running a single raid5 across four 750GB SATA drives (total of
2.25TB capacity, which has turned out to be a huge pain in the ass,
but that's hopefully an unrelated story).

I would love to know why it works fine with 2.6.32 but fails completely
with 2.6.37.  I can't find any commits in git that seem major enough to
really affect things, but clearly something did.  I am somewhat worried
my next kernel upgrade won't go well.

-- 
Len Sorensen
