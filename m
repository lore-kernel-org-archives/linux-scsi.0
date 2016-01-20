From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi: add checks for dma mapping errors
Date: Tue, 19 Jan 2016 19:59:38 -0500
Message-ID: <yq1fuxtqd51.fsf@sermon.lab.mkp.net>
References: <1452894334-8984-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47376 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbcATBAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 20:00:00 -0500
In-Reply-To: <1452894334-8984-1-git-send-email-khoroshilov@ispras.ru> (Alexey
	Khoroshilov's message of "Sat, 16 Jan 2016 00:45:34 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

>>>>> "Alexey" == Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

Alexey> hwi_write_buffer() does not check if mapping dma memory succeed.
Alexey> The patch adds the check and failure handling.

Jitendra, please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
