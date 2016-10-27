From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: Fix memory leak if LBP enabled and module is unloaded
Date: Wed, 26 Oct 2016 22:11:06 -0400
Message-ID: <yq1shri5yo5.fsf@sermon.lab.mkp.net>
References: <1477495373-1179-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39457 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932707AbcJ0CLM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 22:11:12 -0400
In-Reply-To: <1477495373-1179-1-git-send-email-emilne@redhat.com> (Ewan
        D. Milne's message of "Wed, 26 Oct 2016 11:22:53 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> map_storep was not being vfree()'d in the module_exit call.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
