From: "dingo" <vangoph@stinfo.net>
Subject: why do scsi disk performance decline in SMP ?
Date: Wed, 27 Nov 2002 15:43:14 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <as1su2$3us$1@main.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 18GxHA-000313-00
	for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2002 09:10:28 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,
   I run three copy processes in redhat7.2 on SMP platform simultaneously,
which copy 1GB data from three windows client to linux server by samba, I
found that the sector block number of the scsi command that my driver
received is very discontiguous. so, it decline my scsi disk performance. but
I run the same three copy processes in UP, the sector block number of the
scsi command that my driver received is very contiguous. I don't know why?
could anybody give me some suggestion? Any help is appreciative.




