From: James Bottomley <James.Bottomley@steeleye.com>
Subject: 2.6.0 stability and the BK scsi trees
Date: 16 Oct 2003 06:29:28 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066265974.16761.426.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:4102 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262114AbTJPA7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2003 20:59:40 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h9G0xat23451
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2003 20:59:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

In the light of the recently announced "bug fixes only" edict for the
2.6 kernel, I'll be splitting our current SCSI BK tree:

bk://linux-scsi.bkbits.net/scsi-misc-2.5

Into two trees.  One:

bk://linux-scsi.bkbits.net/scsi-bugfixes-2.6

for upstream inclusion, and the other

bk://linux-scsi.bkbits.net/scsi-misc-2.7

To hold all the other stuff for eventual inclusion in 2.7.

I'll be on Holiday until 22 October, but I'll try to do this shortly
after I get back home.

If you send any patches to the SCSI list in the mean time, could you
make sure you label them "bug fix" (and make sure they really are) if
they are for immediate inclusion.

Thanks,

James




