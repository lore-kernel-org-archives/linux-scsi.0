From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] qla4xxx: skip error recovery in case of register
 disconnect.
Date: Tue, 13 Feb 2018 15:16:01 +0100
Message-ID: <704c1857-ab5c-1955-d8cd-60cae6795b27@redhat.com>
References: <20180212064841.24503-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964982AbeBMOQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 09:16:03 -0500
In-Reply-To: <20180212064841.24503-1-manish.rangankar@cavium.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

On 02/12/2018 07:48 AM, Manish Rangankar wrote:
> A system crashes when continuously removing/re-adding
> the storage controller.
>
> Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
