From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: 2.4.20 & gcc-3: bug in aic7xxx_osm.c
Date: Tue, 29 Apr 2003 09:37:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EAE47CD.15147.4FCF87@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rrzd2.rz.uni-regensburg.de ([132.199.1.12]:22929 "EHLO
	rrzd2.rz.uni-regensburg.de") by vger.kernel.org with ESMTP
	id S261283AbTD2HZe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 03:25:34 -0400
Received: from kgate.dvm.klinik.uni-regensburg.de ([132.199.176.18])
	by rrzd2.rz.uni-regensburg.de (8.12.3/8.12.3/Debian -4) with ESMTP id h3T7bpr0000377
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2003 09:37:51 +0200
Received: from rkdvmks1.ngate.uni-regensburg.de (rkdvmks1.dvm.klinik.uni-regensburg.de [132.199.176.1])
	by kgate.dvm.klinik.uni-regensburg.de (8.11.6/8.11.6/20021112M-1) with ESMTP id h3T7bf601308
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2003 09:37:41 +0200
Content-description: Mail message body
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

possibly fixed for a long time, but any way:
The gcc shipped with SuSE Linux 8.2 cannot compile Linux-2.4.20, because of a 
syntax problem in aic7xxx_osm.c:

There is a long string like this

"string
second line
third line
"

Regards,
Ulrich

