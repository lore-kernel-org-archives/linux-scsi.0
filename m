From: Peter Zijlstra <peterz@infradead.org>
Subject: bnx2i kthread madness
Date: Wed, 28 Sep 2011 17:05:18 +0200
Message-ID: <1317222318.24040.46.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43624 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1I1PFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2011 11:05:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>, Eddie Wai <eddie.wai@broadcom.com>

Hi,

I accidentally looked at all kthreads in existence on my system and
found I had:

[iscsi_eh]
[bnx2i_thread/0]
[bnx2i_thread/1]
[bnx2i_thread/2]
[bnx2i_thread/3]
[bnx2i_thread/4]
[bnx2i_thread/5]
[bnx2i_thread/6]
[bnx2i_thread/7]
[bnx2i_thread/8]
[bnx2i_thread/9]
[bnx2i_thread/10]
[bnx2i_thread/11]
[bnx2i_thread/12]
[bnx2i_thread/13]
[bnx2i_thread/14]
[bnx2i_thread/15]
[bnx2i_thread/16]
[bnx2i_thread/17]
[bnx2i_thread/18]
[bnx2i_thread/19]
[bnx2i_thread/20]
[bnx2i_thread/21]
[bnx2i_thread/22]
[bnx2i_thread/23]

This left me wondering why, because I most certainly am not using iSCSI.
I don't even know why its enabled in my .config (and it won't be long). 

Please fix this muck to not create useless threads.


