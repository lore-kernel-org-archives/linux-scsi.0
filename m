From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 04/10] scsi_transport_iscsi: Use flush_work in
 iscsi_remove_session
Date: Fri, 24 Mar 2017 18:22:32 +0100
Message-ID: <773c37d9-2ef4-60ef-aa29-e8183da1e0d0@redhat.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1490344909-29541-5-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751235AbdCXRWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 13:22:41 -0400
In-Reply-To: <1490344909-29541-5-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 24.3.2017 09:41, Jitendra Bhivare wrote:
> scsi_flush_work flushes workqueue for the Scsi_Host.
> In iSCSI offload enabled host, this would wait for all other
> sessions under the host.
>
> Use flush_work for the session being removed instead.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
