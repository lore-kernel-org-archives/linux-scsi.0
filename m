From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/5] target: Fine-tuning for some function
 implementations
Date: Mon, 01 May 2017 20:37:12 -0700
Message-ID: <1493696232.23202.1.camel@haakon3.risingtidesystems.com>
References: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44404 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdEBDhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2017 23:37:14 -0400
In-Reply-To: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

Hi Markus,

Apologies for the delayed follow-up here as well.

On Sun, 2017-04-09 at 21:43 +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 9 Apr 2017 21:33:21 +0200
> 
> A few update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (5):
>   rd: Use kcalloc() in two functions
>   rd: Delete error messages for failed memory allocations
>   rd: Improve size determinations in two functions
>   sbc: Use kmalloc_array() in compare_and_write_callback()
>   transport: Use kmalloc_array() in transport_kmap_data_sg()
> 
>  drivers/target/target_core_rd.c        | 33 +++++++++------------------------
>  drivers/target/target_core_sbc.c       |  4 ++--
>  drivers/target/target_core_transport.c |  2 +-
>  3 files changed, 12 insertions(+), 27 deletions(-)
> 

Applied.

Thank you.
