From: Stas Nikiforov <stas@itam.nsc.ru>
Subject: Huge 1.2TB partition
Date: Fri, 24 Sep 2004 16:50:17 +0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096019417.2726.61.camel@whirl.lab7.lan>
Reply-To: stas@itam.nsc.ru
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.itam.nsc.ru ([194.226.179.15]:49541 "EHLO ns.itam.nsc.ru")
	by vger.kernel.org with ESMTP id S268576AbUIXJus (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 05:50:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi list <linux-scsi@vger.kernel.org>, rocks_list <npaci-rocks-discussion@sdsc.edu>

Hi,
I have RAID 5 6x250 SATA storage.
Is it a good idea to have one huge partition
or it is better to split it on smaller logical drives and then use LVM,
for example?

In any way, what is a preferred filesystem for this storage?
I plan to use it as a mass storage for CFD results.

Thanks in advance,
Stas.
-- 
Mr. Nikiforov Stanislav

Intsitute of Theoretical and Applied Mechanics
4/1, Institutskaya str., 
Novosibirsk, 930090, 
Russia

Voice: +7 3832 343163
E-mail: stas@itam.nsc.ru  

