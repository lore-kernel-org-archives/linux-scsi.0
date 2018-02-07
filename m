From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH v3 1/2] qedi: Fix truncation of CHAP name and secret
Date: Wed, 7 Feb 2018 08:39:54 -0800
Message-ID: <4dca4f0f-54d5-8226-c106-38b911d21bf0@wdc.com>
References: <20180207161236.12975-1-nilesh.javali@cavium.com>
 <20180207161236.12975-2-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:65080 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbeBGQj4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2018 11:39:56 -0500
In-Reply-To: <20180207161236.12975-2-nilesh.javali@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh Javali <nilesh.javali@cavium.com>, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

On 02/07/18 08:12, Nilesh Javali wrote:
> The data in NVRAM is not guaranteed to be NUL terminated.
> Since snprintf expects byte-stream to accommodate null byte,
> the CHAP secret is truncated.
> Use sprintf instead of snprintf to fix the truncation of
> CHAP name and secret.

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Thanks for having addressed the review comments.

Bart.
