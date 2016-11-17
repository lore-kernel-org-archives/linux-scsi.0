From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] fnic: remove a pointless test
Date: Thu, 17 Nov 2016 15:14:12 +0100
Message-ID: <972c0b2d-c614-36bd-cdf1-3c1204cc032b@redhat.com>
References: <1478018421-22820-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753810AbcKQObF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 09:31:05 -0500
In-Reply-To: <1478018421-22820-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sramars@cisco.com, hiralpat@cisco.com, buchino@cisco.com

On 1.11.2016 17:40, Tomas Henzl wrote:
> rport can't be null here, it would have failed already in
> fc_remote_port_chkready
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>

Martin,
another (better) patch  "fnic: Correcting rport check location in fnic_queuecommand_lck"
has been added to 4.10/scsi-queue.

Please drop this one.

Tomas

