From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: Question: 2.4.X and BLIST_SINGLELUN
Date: Tue, 22 Jun 2004 15:51:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Jun22.155126edt.332331@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:3089 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S265109AbUFVTvd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 15:51:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I want to add a BLIST_SINGLELUN blacklist entry to scsi_scan.c (kernel 2.4.X) for a device
that happens to have distinct inquiry strings for LUNs 0 and 1.  Ideally, I would like to
add just one entry using the inquiry string for LUN 1.  Will this work, or does the
blacklist entry have to match the inquiry string for LUN 0?  I can guarantee that all LUNs
will be scanned, so I don't need BLIST_FORCELUN.  I can't experiment with it because I
don't have the device here with me.

Anthony J. Battersby
Cybernetics

