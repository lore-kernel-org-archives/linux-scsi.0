From: wb <dead_email@nospam.com>
Subject: Monitoring FileSystem cache
Date: Wed, 06 Aug 2003 08:32:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F310375.2040207@nospam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ztxmail04.ztx.compaq.com ([161.114.1.208]:40204 "EHLO
	ztxmail04.ztx.compaq.com") by vger.kernel.org with ESMTP
	id S270759AbTHFNZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2003 09:25:29 -0400
Received: from cceexg13.americas.cpqcorp.net (cceexg13.americas.cpqcorp.net [16.110.250.119])
	by ztxmail04.ztx.compaq.com (Postfix) with ESMTP id 625ECACBC
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2003 08:25:25 -0500 (CDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Are there tools available to monitor
the size of the filesystem buffer/cache ?

Are there hi water marks that limit the
size of the buffer cache or does it consume
as such memory VM as possible ?

I looked through /proc ( 2.4.20 kernel )
and I don't see anything of interest.

Curious.

Thanks.

J. Donnelly.

