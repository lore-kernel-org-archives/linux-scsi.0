From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] BusLogic: add error handling, fix queuecommand, docs.
Date: Wed, 1 Oct 2003 14:48:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031001214818.GB1045@beaverton.ibm.com>
References: <20031001122316.6f33af9b.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:38804 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262577AbTJAVoF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2003 17:44:05 -0400
Content-Disposition: inline
In-Reply-To: <20031001122316.6f33af9b.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org

Randy.Dunlap [rddunlap@osdl.org] wrote:
> +/* Error Handling (EH) support */
> +
> +static int BusLogic_abort(Scsi_Cmnd *SCpnt)
> +{
> +	return FAILED;
> +}
> +
> +static int BusLogic_bus_reset(Scsi_Cmnd *SCpnt)
> +{
> +	return FAILED;
> +}
> +
> +static int BusLogic_device_reset(Scsi_Cmnd *SCpnt)
> +{
> +	return FAILED;
> +}
> +

If the functions are just going to return FAILED you may want to
consider leaving them out. Having these functions return fail will cause
the output to be noisy. Either with this noisy output or not the
recovery will end up at BusLogic_host_reset.

-andmike
--
Michael Anderson
andmike@us.ibm.com

