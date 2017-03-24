From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 02/10] be2iscsi: Fix closing of connection
Date: Fri, 24 Mar 2017 14:17:37 +0100
Message-ID: <dca7d4a8-bb5a-8bd0-ff7d-958d394b3057@redhat.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1490344909-29541-3-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14399 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751477AbdCXNRj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 09:17:39 -0400
In-Reply-To: <1490344909-29541-3-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 24.3.2017 09:41, Jitendra Bhivare wrote:
> CID needs to be freed even when invalidate or upload connection fails.
> Attempt to close connection 3 times before freeing CID.
>
> Set cleanup_type to INVALIDATE instead of force TCP_RST.
> This unnecessarily is terminating connection with reset instead of
> gracefully closing it.
>
> Set save_cfg to 0 - session not to be saved on flash.
>
> Add delay and process CQ before uploading connection.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
