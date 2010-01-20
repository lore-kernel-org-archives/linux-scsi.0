From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: entries in sysfs regarding enclosures seem not being updated after
 hot plugging
Date: Wed, 20 Jan 2010 09:57:33 +0100
Message-ID: <20100120095733.f65474fa.taeuber@bbaw.de>
References: <20100118114624.fea646be.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:33070 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0ATI5f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2010 03:57:35 -0500
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id DC1BE4A806C
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2010 09:57:32 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 90ED8937FD
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2010 09:57:33 +0100 (CET)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 7B3DF937B4
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2010 09:57:33 +0100 (CET)
In-Reply-To: <20100118114624.fea646be.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hallo!

I might be wrong on this mailing list. Is there a special sysfs ML?

Please point me out a place to look next with my problem.

I should have mentioned the kernel version and enclosure type:
# uname -a
Linux speicher48 2.6.31-17-server #54-Ubuntu SMP Thu Dec 10 18:06:56 UTC 2009 x86_64 GNU/Linux
# cat /sys/class/enclosure/10\:0\:24\:0/device/vendor 
CHENBRO 
# cat /sys/class/enclosure/10\:0\:24\:0/device/model 
SASX36 B0       


Regards
Lars
