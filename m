From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/11] qla2xxx: Add framework for Async fabric discovery.
Date: Wed, 11 Jan 2017 12:08:13 -0800
Message-ID: <8aa94926-c319-7ba2-f894-88cbb08ab826@sandisk.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0071.outbound.protection.outlook.com ([104.47.41.71]:6048
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752490AbdAKUIT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 15:08:19 -0500
In-Reply-To: <1482553419-4117-9-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On 12/23/2016 08:23 PM, Himanshu Madhani wrote:
> +	sess->logout_completed = 0;
> +	be_sid[0] = sess->d_id.b.domain;
> +	be_sid[1] = sess->d_id.b.area;
> +	be_sid[2] = sess->d_id.b.al_pa;

Hello Himanshu and Quinn,

When building the qlt_create_sess() code with W=1 the compiler warns
that values are assigned to the elements of the be_sid[] array but that
these values are not used. Please review the code.

Thanks,

Bart.
