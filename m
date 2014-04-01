From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/4] target/core: T10-Dif: check HW support capabilities
Date: Tue, 01 Apr 2014 13:09:37 -0400
Message-ID: <yq1k3b9x9gu.fsf@sermon.lab.mkp.net>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
	<1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>
	<53360E54.5060004@mellanox.com>
	<504EB66DAC8D234EB8E8560985C2D7AD46CE87D7@avmb2.qlogic.org>
	<533620C0.9060903@mellanox.com>
	<504EB66DAC8D234EB8E8560985C2D7AD46CE9B32@avmb2.qlogic.org>
	<1396315146.22665.82.camel@haakon3.risingtidesystems.com>
	<533A71E9.90308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30492 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaDARJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2014 13:09:52 -0400
In-Reply-To: <533A71E9.90308@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Tue, 01 Apr 2014 10:59:37 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Quinn Tran <quinn.tran@qlogic.com>, sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi> I originally wrote the code to support that. But it got left
Sagi> behind since I figured it is not an interesting use-case.  If your
Sagi> beckend doesn't support T10-PI why should the target publish it
Sagi> support it and ask the device to strip/insert it?  I suppose it is
Sagi> to allow the initiator to protect half-way, but I don't know how
Sagi> interesting it is if the data is not stored with protection...

That depends what you do on the backend. There are several devices out
there that expose PI to the host but use a different protection scheme
internally. And then synthesize PI on the host-facing side. Some even do
T10 PI to an internal protection scheme and then back to T10 PI when
talking to the disk drives in the back end.

-- 
Martin K. Petersen	Oracle Linux Engineering
