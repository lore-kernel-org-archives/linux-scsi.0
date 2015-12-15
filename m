From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on ppc64 host
Date: Tue, 15 Dec 2015 10:38:24 -0500
Message-ID: <yq1mvtbwwlr.fsf@sermon.lab.mkp.net>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26411 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283AbbLOPi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 10:38:29 -0500
In-Reply-To: <20151215112057.GC19209@eguan.usersys.redhat.com> (Eryu Guan's
	message of "Tue, 15 Dec 2015 19:20:57 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Eryu" == Eryu Guan <guaneryu@gmail.com> writes:

Eryu,

Eryu> This is still reproducible with 4.4-rc5 kernel.

Sorry about the delay. I've been busy with a lab move and most of my
machines have been disconnected since last week. Almost done getting my
equipment back online.

However, I think I have found the smoking gun. More in a bit...

-- 
Martin K. Petersen	Oracle Linux Engineering
