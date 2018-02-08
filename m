From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH v3 1/2] qedi: Fix truncation of CHAP name and secret
Date: Thu, 8 Feb 2018 11:39:43 -0800
Message-ID: <5f0261b4-4a5d-a4e2-4c36-7897deb2bf55@suse.com>
References: <20180207161236.12975-1-nilesh.javali@cavium.com>
 <20180207161236.12975-2-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752255AbeBHTjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Feb 2018 14:39:48 -0500
In-Reply-To: <20180207161236.12975-2-nilesh.javali@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh Javali <nilesh.javali@cavium.com>, martin.petersen@oracle.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

On 02/07/2018 08:12 AM, Nilesh Javali wrote:
> From: Andrew Vasquez <andrew.vasquez@cavium.com>
> 
> The data in NVRAM is not guaranteed to be NUL terminated.
> Since snprintf expects byte-stream to accommodate null byte,
> the CHAP secret is truncated.
> Use sprintf instead of snprintf to fix the truncation of
> CHAP name and secret.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@cavium.com>
> Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> ...

Signed-off-by: Lee Duncan <lduncan@suse.com>

-- 
Lee Duncan
