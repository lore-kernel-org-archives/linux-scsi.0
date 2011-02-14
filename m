From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 02:29:49 -0800
Message-ID: <1297679389.21049.32.camel@haakon2.linux-iscsi.org>
References: <20110214192600L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37846 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNKgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 05:36:21 -0500
In-Reply-To: <20110214192600L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, brking@linux.vnet.ibm.com

On Mon, 2011-02-14 at 19:25 +0900, FUJITA Tomonori wrote:
> This is the third version of tcm ibmvscsis driver. You can find the
> first version at:
> 
> http://marc.info/?t=129734085600004&r=1&w=2
> 
> The changes are:
> v3:
> - fix task attribute (convert MSG_* to TASK_ATTR_*)
> v2:
> - send VIOSRP_MAD_NOT_SUPPORTED for unknown mad type requests.
> - fix inquiry typo
> - sends task management response (for now, 'NOT SUPPORTED').
> - remove dead code.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH v3 3/3] tcm ibmvscsis driver
> 
> This replaces ibmvstgt driver that uses the old target framework.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/ibmvscsi/Makefile    |    4 +-
>  drivers/scsi/ibmvscsi/ibmvscsis.c | 1761 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 1764 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/scsi/ibmvscsi/ibmvscsis.c
> 

Merged and pushed your rev3 changes into lio-core-2.6.git/tcm_ibmvscsis

Thanks again Tomo-san!

--nab

