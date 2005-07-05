From: Andrea Carpani <andrea.carpani@criticalpath.net>
Subject: Latest aic79xx drivers
Date: Tue, 05 Jul 2005 17:11:43 +0200
Message-ID: <1120576303.9595.34.camel@cronos.criticalpath.it>
Reply-To: andrea.carpani@criticalpath.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plutone.criticalpath.it ([192.92.105.11]:25279 "EHLO
	mail.criticalpath.it") by vger.kernel.org with ESMTP
	id S261863AbVGEPLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2005 11:11:48 -0400
Received: from cronos.criticalpath.it (192.92.105.117) by mail.criticalpath.it (7.2.056.2)
        id 42A028690000732B for linux-scsi@vger.kernel.org; Tue, 5 Jul 2005 17:11:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi everybody.

I think I need some help with aic79xx drivers, can you help?

Last year I tried aic79xx ver 1.3.11 that came with linux 2.6.8.1, but
it randomly crashed on my Tyan box.
I since used adaptec's driver version 2.0.12 and all seems to go well.
I now have to update linux kernel (2.6.12.2) and aic79xx still sits at
1.3.11 while adaptec has a 2.0.14 patch.

The problem is that this patch doesn't seem to compile as something must
have changed in the includes of the latest kernels (SCSI_DATA_READ'
undeclared (first use in this function)).

Any ideas?

-- 
Andrea Carpani <andrea.carpani@criticalpath.net>

