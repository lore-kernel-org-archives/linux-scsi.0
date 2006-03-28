From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] aic94xx: move entirely over to correct transport class formulation
Date: Mon, 27 Mar 2006 21:39:02 -0800
Message-ID: <20060328053902.GA15968@us.ibm.com>
References: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:11406 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751314AbWC1FjG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 00:39:06 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2S5d67G010936
	for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2006 00:39:06 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2S5ZvUw228610
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 22:35:57 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2S5d5mZ002382
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 22:39:05 -0700
Content-Disposition: inline
In-Reply-To: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> +#include <scsi/scsi_transport.h>
> +#include <scsi/scsi_transport_sas.h>
> +#include "../scsi_sas_internal.h"


I did a git pull from the aic tree and scsi-misc, and applied your patch.
Was scsi_sas_internal.h suppose to be in this patch?

-andmike
--
Michael Anderson
andmike@us.ibm.com
