From: Douglas Gilbert <dougg@torque.net>
Subject: sg kill local jiffies problems
Date: Sun, 05 Sep 2004 12:18:52 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413A778C.1000302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:64460 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S265928AbUIECTc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2004 22:19:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bunk@fs.tum.de, Michel.R.Garnier@wanadoo.fr

It has been reported that the change to sg.c in lk 2.6.9-rc1-bk5
to use library jiffy functions breaks sg (albeit under vmware).
Evidentally sg devices are no longer recognised after that change.

Reverting that changeset removes the problem. Strange, it is not
obvious why.

At some stage I must have detected negative time spans (yeh yeh it
never happens) and my versions returned 0 in this case; otherwise
the implementations look very similar.

Doug Gilbert
