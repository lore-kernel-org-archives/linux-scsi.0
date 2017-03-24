From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 06/10] be2iscsi: Use num_cons field in Rx CQE
Date: Fri, 24 Mar 2017 18:17:11 +0100
Message-ID: <093f9b61-5088-a2d7-e9b9-83baff26cf15@redhat.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1490344909-29541-7-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966906AbdCXRRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 13:17:13 -0400
In-Reply-To: <1490344909-29541-7-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 24.3.2017 09:41, Jitendra Bhivare wrote:
> FW runs out of buffer if buffers are not posted back soon.
> ASYNC Rx CQE indicates that FW has consumed 8 RQEs.
> Use it to post back buffers instead of waiting for buffers
> to be processed and freed by driver.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
