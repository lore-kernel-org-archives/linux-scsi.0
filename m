From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: sg: Avoid overflow when USER_HZ > HZ
Date: Thu, 25 Aug 2016 23:27:49 -0400
Message-ID: <yq1inuo9pl6.fsf@sermon.lab.mkp.net>
References: <20160819164357.26121-1-paul.burton@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19158 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbcHZD3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2016 23:29:20 -0400
In-Reply-To: <20160819164357.26121-1-paul.burton@imgtec.com> (Paul Burton's
        message of "Fri, 19 Aug 2016 17:43:56 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Burton <paul.burton@imgtec.com>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>

>>>>> "Paul" == Paul Burton <paul.burton@imgtec.com> writes:

Paul> Calculating the maximum timeout that a user can set via the
Paul> SG_SET_TIMEOUT ioctl involves multiplying INT_MAX by
Paul> USER_HZ/HZ. If USER_HZ is larger than HZ then this results in an
Paul> overflow when performed as a 32 bit integer calculation, resulting
Paul> in compiler warnings such as the following:

Doug: Please review.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
