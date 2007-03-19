From: Andreas Steinmetz <ast@domdv.de>
Subject: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Date: Mon, 19 Mar 2007 01:34:22 +0100
Message-ID: <45FDDA8E.8030100@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.domdv.de ([193.102.202.1]:1046 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXCSAeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Mar 2007 20:34:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

As posted to lkml and linux-scsi on 2007-03-15 without reply, see
http://marc.info/?l=linux-kernel&m=117395128412313&w=2 for original post:

It is not so nice when one can write backup tapes but the tapes cannot
be read. I don't know if memory management or the st driver is the
culprit, but this is a not so nice situation.

I can't even say if the tapes are written correctly as I can't read them
(one does not reboot production machines back to 2.4.x just to try to
read a backup tape - I don't have 2.6.x older than 2.6.20 on these
machines).
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de

