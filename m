From: "Szloboda Zsolt" <slobo@t-online.hu>
Subject: raid over sata - write barrier
Date: Fri, 16 Dec 2005 14:01:01 +0100
Message-ID: <JDEMIGCBPIDENEAIIGKPKEBMCLAA.slobo@t-online.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from akac.mail.t-online.hu ([195.228.240.96]:37135 "EHLO
	akac.mail.t-online.hu") by vger.kernel.org with ESMTP
	id S932252AbVLPNBC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2005 08:01:02 -0500
Received: from tresnyevac (dsl51B6A080.pool.t-online.hu [81.182.160.128])
	by akac.mail.t-online.hu (8.13.4/8.12.11) with SMTP id jBGD10Pb045033
	for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2005 14:01:01 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've found that ext3 + sata + kernel 2.6.12 supports the write barrier mount
option (-o barrier=1)
(found it here: http://marc.10east.com/?l=linux-scsi&m=112019898711806)

is write barrier supported with RAID (md) over sata, with ext3? (which
kernel version?)
(or we have to disable write cache in HD in this case?)

thanks

