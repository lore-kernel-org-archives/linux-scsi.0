From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH trivial] fcoe: use defines from ethtool for 20Gbit and 40Gbit speeds
Date: Wed, 13 Jul 2016 22:26:10 -0400
Message-ID: <yq17fcplzul.fsf@sermon.lab.mkp.net>
References: <1467898918-90352-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36877 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcGNCeu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 22:34:50 -0400
In-Reply-To: <1467898918-90352-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Thu, 7 Jul 2016 15:41:58 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Jiri Kosina <trivial@kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, fcoe-devel@open-fcoe.org

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Use defines from ethtool for 20Gbit and 40Gbit speeds instead
Johannes> of magic numbers.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
