From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on ppc64 host
Date: Tue, 05 Jan 2016 18:58:25 -0500
Message-ID: <yq17fjnk28u.fsf@sermon.lab.mkp.net>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20160105115735.GA21068@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38716 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcAEX6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2016 18:58:30 -0500
In-Reply-To: <20160105115735.GA21068@eguan.usersys.redhat.com> (Eryu Guan's
	message of "Tue, 5 Jan 2016 19:57:35 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Eryu" == Eryu Guan <guaneryu@gmail.com> writes:

Eryu> Any updates on this? It's still reproducible with 4.4-rc8 kernel,
Eryu> and still blocks some of my tests :)

http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/log/?h=4.4/scsi-fixes

It just hasn't made it to Linus yet...

-- 
Martin K. Petersen	Oracle Linux Engineering
