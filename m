From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: Comparison of features between different SCSI targets
 (SCST, STGT, IET, LIO) updated
Date: Thu, 02 Sep 2010 23:31:17 +0400
Message-ID: <4C7FFB85.7000006@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab0IBTbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 15:31:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ross Walker <rswwalker@gmail.com>

Hello,

I updated the Linux SCSI targets comparison page 
http://scst.sourceforge.net/comparison.html, which compares features of 
the existing Linux SCSI target subsystems. The comparison includes SCST, 
STGT, IET and LIO. I added IET there, because it is the most used Linux 
iSCSI target at the moment.

This page is intended to be a complete and fair feature-by-feature 
comparison between the targets. The only thing I have not added there is 
quality of various corner cases recovery, because I don't know how to 
measure that. SCST is really good in this area, while some other targets 
are often not too much, but I have no idea how to summarize it in an 
objective view.

If you see I'm wrong somewhere or forgot something, you are welcome to 
correct me and I will fix that.

Vlad


