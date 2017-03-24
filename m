From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 08/10] be2iscsi: Check size before copying ASYNC handle
Date: Fri, 24 Mar 2017 18:19:13 +0100
Message-ID: <047abe32-0bcc-57ce-9265-8916e3a39130@redhat.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1490344909-29541-9-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966918AbdCXRTP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 13:19:15 -0400
In-Reply-To: <1490344909-29541-9-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 24.3.2017 09:41, Jitendra Bhivare wrote:
> Data in buffers are gathered into a single buffer before giving to
> iSCSI layer. Though less likely to have payload more than 8K in
> ASYNC PDU, the data length is provide by FW and check is missing
> for overrun.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
