From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] enclosure: fix sysfs symlinks creation when using multipath
Date: Wed, 15 Mar 2017 19:39:31 -0400
Message-ID: <yq1varaf6to.fsf@oracle.com>
References: <1488454204-21251-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21805 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdCOXjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 19:39:39 -0400
In-Reply-To: <1488454204-21251-1-git-send-email-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Thu, 2 Mar 2017 12:30:04 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Maurizio Lombardi <mlombard@redhat.com> writes:

> With multipath, it may happen that the same device is passed to
> enclosure_add_device() multiple times and that the
> enclosure_add_links() function fails to create the symlinks because
> the device's sysfs directory entry is still NULL.  In this case, the
> links will never be created because all the subsequent calls to
> enclosure_add_device() will immediately fail with EEXIST.

James?

-- 
Martin K. Petersen	Oracle Linux Engineering
