From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 05/10] be2iscsi: Increase HDQ default queue size
Date: Fri, 24 Mar 2017 18:23:19 +0100
Message-ID: <b7fdb609-ea70-2056-dabd-6902ffc88e28@redhat.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1490344909-29541-6-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751369AbdCXRXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 13:23:21 -0400
In-Reply-To: <1490344909-29541-6-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 24.3.2017 09:41, Jitendra Bhivare wrote:
> Currently, ASYNC PDU default queue size is set to max connections.
> This leaves only one buffer per connection for any ASYNC PDUs from
> targets.
>
> Double the size of the default queue.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
