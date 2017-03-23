From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 03/10] be2iscsi: Replace spin_unlock_bh with spin_lock
Date: Thu, 23 Mar 2017 18:03:51 +0100
Message-ID: <62aefc9b-2f7d-6f81-6920-bbd79cc12672@redhat.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1489634685-4975-4-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935085AbdCWRDz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Mar 2017 13:03:55 -0400
In-Reply-To: <1489634685-4975-4-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 16.3.2017 04:24, Jitendra Bhivare wrote:
> spin_unlock_bh back_lock is used in beiscsi_eh_device_reset instead of
> spin_lock.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
