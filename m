From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh_alua: fix missing kref_put() in alua_rtpg_work()
Date: Tue, 01 Nov 2016 09:44:16 -0400
Message-ID: <yq17f8n2u33.fsf@sermon.lab.mkp.net>
References: <1477641247-9632-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19636 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1169195AbcKANoY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 09:44:24 -0400
In-Reply-To: <1477641247-9632-1-git-send-email-tang.junhui@zte.com.cn> (tang
        junhui's message of "Fri, 28 Oct 2016 15:54:07 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: hare@suse.de, matthew@wil.cx, linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn

>>>>> "tang" == tang junhui <tang.junhui@zte.com.cn> writes:

tang> Reference count of pg leaks in alua_rtpg_work() since kref_put()
tang> is not called to decrease the reference count of pg when the
tang> condition
tang> pg->rtpg_sdev==NULL satisfied (actually it is easy to satisfy), it
tang> would cause memory of pg leakage.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
