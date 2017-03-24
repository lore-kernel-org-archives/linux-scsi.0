From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 07/10] be2iscsi: Remove free_list for ASYNC handles
Date: Fri, 24 Mar 2017 18:18:19 +0100
Message-ID: <58d1ca0a-6c76-893b-c9dc-fcbfa42ba260@redhat.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1490344909-29541-8-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966927AbdCXRS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 13:18:26 -0400
In-Reply-To: <1490344909-29541-8-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 24.3.2017 09:41, Jitendra Bhivare wrote:
> With previous patch adding ASYNC Rx buffers to free_list is not required.
> Remove all free_list related operations.
>
> Add in_use to track if buffer posted is being processed by driver and
> purge all buffers received for connection if found so.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
