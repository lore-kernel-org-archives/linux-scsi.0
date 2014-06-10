From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 10 Jun 2014 16:21:43 -0400
Message-ID: <yq138fcv7l4.fsf@sermon.lab.mkp.net>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
	<1402223228-23768-2-git-send-email-sagig@mellanox.com>
	<yq1fvjcvb8f.fsf@sermon.lab.mkp.net>
	<CAJZOPZ+sc2uvCqQQpo+KO8q9+u6X5je+-AnCiijX6K9q2w2yrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37984 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbaFJUWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 16:22:20 -0400
In-Reply-To: <CAJZOPZ+sc2uvCqQQpo+KO8q9+u6X5je+-AnCiijX6K9q2w2yrQ@mail.gmail.com>
	(Or Gerlitz's message of "Tue, 10 Jun 2014 23:19:29 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Roland Dreier <roland@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

>>>>> "Or" == Or Gerlitz <or.gerlitz@gmail.com> writes:

Or> Just to make sure, by 3.16 you also mean 3.15.y, right?

Yes.

-- 
Martin K. Petersen	Oracle Linux Engineering
