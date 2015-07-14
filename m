From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] qla2xxx: use t10_pi_tuple
Date: Mon, 13 Jul 2015 21:28:30 -0400
Message-ID: <yq14ml7ttmp.fsf@sermon.lab.mkp.net>
References: <20150712235425.00001970@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49283 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbGNB2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2015 21:28:39 -0400
In-Reply-To: <20150712235425.00001970@localhost> (Sebastian Herbszt's message
	of "Sun, 12 Jul 2015 23:54:25 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, Bart Van Assche <bart.vanassche@sandisk.com>

>>>>> "Sebastian" == Sebastian Herbszt <herbszt@gmx.de> writes:

Sebastian> Drop unused scsi_dif_tuple and use t10_pi_tuple instead of
Sebastian> own sd_dif_tuple copy.  Also use sg_virt() instead of open
Sebastian> coding it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
