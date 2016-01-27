From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hisi_sas: add dependency for HAS_IOMEM
Date: Tue, 26 Jan 2016 21:17:24 -0500
Message-ID: <yq1y4bbhikr.fsf@sermon.lab.mkp.net>
References: <1453809552-240944-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18721 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbcA0CRr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 21:17:47 -0500
In-Reply-To: <1453809552-240944-1-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Tue, 26 Jan 2016 19:59:12 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, richard@nod.at, geert@linux-m68k.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> Not every arch has io, so fix build by adding necessary
John> dependency.

Ignore previous mail. Will apply this...

-- 
Martin K. Petersen	Oracle Linux Engineering
