From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [v4 PATCH 1/5] libfcoe: Move common code from fcoe.c to
 libfcoe.c
Date: Tue, 25 Jan 2011 23:53:55 -0800
Message-ID: <7C88852EF6F99F4EB538472FCFEBE222014AA137B0@orsmsx509.amr.corp.intel.com>
References: <1296010665.3536.2586.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1AZHyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2011 02:54:18 -0500
In-Reply-To: <1296010665.3536.2586.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Michael Chan <mchan@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

> 
> fcoe_start_io and fcoe_fc_crc are moved to libfcoe so that both
> fcoe and bnx2fc drivers can use these common functions.
> 
> As part of this change, fixed fcoe_start_io to return ENOMEM if
> skb_clone fails.
> 
> Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
> ---
>  drivers/scsi/fcoe/fcoe.c      |   58 -----------------------------------
> --
>  drivers/scsi/fcoe/fcoe_ctlr.c |   63
> +++++++++++++++++++++++++++++++++++++++++
>  include/scsi/libfcoe.h        |    2 +
>  3 files changed, 65 insertions(+), 58 deletions(-)
> 
I thought you were moving to fcoe_transport.c? Also, the patch title
needs fixing to reflect this as there is no libfcoe.c any more.

Thanks,
yi

>
> <-- snip -->
>
