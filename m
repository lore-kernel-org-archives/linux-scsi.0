From: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
Subject: lpfc: System freezing if fiber is broken
Date: Tue, 26 Jul 2005 19:57:54 +0200
Message-ID: <42E679A2.1060408@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:49710 "EHLO
	dgate1.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S261995AbVGZR6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 13:58:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Hi James,

disrupting a working FC connection makes my i386 SMP server
(2.6.12.2) freeze just one or two seconds after this.
I'm normally using lpfc_nodev_tmo = 1. When I change this to the
default value of 35, the system stalls about 36 seconds after
disruption. So I guess, the problem is caused by nodev_tmo
expiring.
I activated the nmi_watchdog, but no output.

What can I do to analyze this problem?

Regards
	Bodo


BTW:
I couldn't reproduce the problem of a wrong WWPN yet.
