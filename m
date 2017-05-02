From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Add WRITE_VERIFY_16
Date: Mon, 01 May 2017 21:57:35 -0700
Message-ID: <1493701055.23202.46.camel@haakon3.risingtidesystems.com>
References: <1492542605-98815-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50403 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdEBE5h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 00:57:37 -0400
In-Reply-To: <1492542605-98815-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, 2017-04-18 at 14:10 -0500, Bryant G. Ly wrote:
> This patch addresses clients who needs write_verify_16 for
> large volume groups such as AIX.
> 
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_sbc.c | 2 ++
>  include/scsi/scsi_proto.h        | 1 +
>  2 files changed, 3 insertions(+)

Applied.

Thanks Bryant.
