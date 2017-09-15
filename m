From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Remove unnecessary condition in sd_read_block_limits()
Date: Thu, 14 Sep 2017 21:09:36 -0400
Message-ID: <yq1shforcmn.fsf@oracle.com>
References: <1505312986-14777-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29182 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbdIOBJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2017 21:09:42 -0400
In-Reply-To: <1505312986-14777-1-git-send-email-lczerner@redhat.com> (Lukas
        Czerner's message of "Wed, 13 Sep 2017 16:29:46 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-scsi@vger.kernel.org


Lukas,

> After series of changes around WRITE_SAME and UNMAP setup we ended up
> with leftover unnecessary condition. Remove it.

Yeah, lbprz went away and made it redundant. Applied to
4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
