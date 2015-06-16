From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: optimal io size / custom alignment
Date: Tue, 16 Jun 2015 17:28:20 -0400
Message-ID: <yq1d20vfimj.fsf@sermon.lab.mkp.net>
References: <CAGnHSE=gtd2WVcxOBoyfqnp3QtT4RHfK356GHastBbiK5mtmFA@mail.gmail.com>
	<20150615133154.GV1992@ws.net.home>
	<CAGnHSEm6wDq_EjJXYwqV2Tt2868DbR0bNRYvevhN1AM4qJpaPw@mail.gmail.com>
	<yq1zj3zfuna.fsf@sermon.lab.mkp.net>
	<CAGnHSEkBXevNmrL7NFO=nKekZdZE6KtzjGvA8sM=onjUfd8KHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37177 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbFPV2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2015 17:28:30 -0400
In-Reply-To: <CAGnHSEkBXevNmrL7NFO=nKekZdZE6KtzjGvA8sM=onjUfd8KHQ@mail.gmail.com>
	(Tom Yan's message of "Wed, 17 Jun 2015 03:26:20 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org, linux-usb@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> All drives I have are flash drives so none of them reports 4k
Tom> physical sectors.

There are plenty of SSDs that report 4K physical sectors, fwiw.

Tom> The usb-storage driver does not read vpd so it won't be a thing,
Tom> but the the uas driver does.

We gave up on USB-SATA bridges long ago. Their designers appear to have
a pretty comprehensive misunderstanding of both the ATA and SCSI
protocols.

We had higher hopes for UAS since it provided a clean slate. So far,
however, the results are equally discouraging.

Tom> I just feel like the kernel shouldn't bind values from totally
Tom> different source (raid stripe vs vpd limit) to the same variable.

RAID devices communicate the stripe width through the Block Limits VPD.

-- 
Martin K. Petersen	Oracle Linux Engineering
