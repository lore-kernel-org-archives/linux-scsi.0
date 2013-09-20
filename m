From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: dif sector calculation
Date: Fri, 20 Sep 2013 18:31:43 -0400
Message-ID: <yq1ob7ndt0w.fsf@sermon.lab.mkp.net>
References: <1379475143-2792-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48833 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3ITWbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:31:50 -0400
In-Reply-To: <1379475143-2792-1-git-send-email-keith.busch@intel.com> (Keith
	Busch's message of "Tue, 17 Sep 2013 21:32:23 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ric Wheeler <rwheeler@redhat.com>

>>>>> "Keith" == Keith Busch <keith.busch@intel.com> writes:

Keith> The ref tag should be the device's physical LBA rather than the
Keith> 512 byte bio sector.

The bip sector is just a seed value set by the application. It is not
correct to scale it based on sector size or PI interval.

-- 
Martin K. Petersen	Oracle Linux Engineering
