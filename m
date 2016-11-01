From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh_alua: fix wrong scsi_device_put() in alua_rtpg_queue()
Date: Tue, 01 Nov 2016 09:43:47 -0400
Message-ID: <yq1bmxz2u3w.fsf@sermon.lab.mkp.net>
References: <1477642877-10228-1-git-send-email-tang.junhui@zte.com.cn>
        <96621137-8209-634e-3d70-ffd89319f103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46787 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1169191AbcKANoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 09:44:01 -0400
In-Reply-To: <96621137-8209-634e-3d70-ffd89319f103@sandisk.com> (Bart Van
        Assche's message of "Fri, 28 Oct 2016 08:05:12 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: tang.junhui@zte.com.cn, hare@suse.de, matthew@wil.cx, linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart,

Bart> Personally I prefer the patch below because that patch does not
Bart> introduce a new variable. This is a patch I started testing four
Bart> weeks ago and it has survived all my ALUA tests so far. Please
Bart> note that I do not know whether my tests hit the !(pg->flags &
Bart> ALUA_PG_RUNNING) code path.

Please submit a real patch with a suitable description for this.

-- 
Martin K. Petersen	Oracle Linux Engineering
