From: Luben Tuikov <luben@splentec.com>
Subject: Autosense requirement
Date: Mon, 29 Jul 2002 09:02:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D453CE8.5A15FCD6@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g6TD2Vs07992
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 09:02:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

How safe am I to assume that SCSI LLDD will return
autosense for a failed/incomplete command, as per
SCSI core (mid-layer) error handling requrement?
(e.g. ide-scsi doesn't return autosense)

In drafts I'm more and more seeing 
``targets MUST support and enable autosense.''

If indeed we put a ``MUST'' requirement on SCSI LLDD
to support and enable autosense, which will indeed
streamline things, then this will save me a an _irq_
spin lock over a simple spin lock...

What is the future of this requrement?

-- 
Luben
