From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] BusLogic: add error handling, fix queuecommand, docs.
Date: Wed, 1 Oct 2003 14:43:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031001144324.60097c36.rddunlap@osdl.org>
References: <20031001122316.6f33af9b.rddunlap@osdl.org>
	<20031001214818.GB1045@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:29149 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262627AbTJAVvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2003 17:51:35 -0400
In-Reply-To: <20031001214818.GB1045@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 1 Oct 2003 14:48:18 -0700 Mike Anderson <andmike@us.ibm.com> wrote:

| Randy.Dunlap [rddunlap@osdl.org] wrote:
| > +/* Error Handling (EH) support */
| > +
| > +static int BusLogic_abort(Scsi_Cmnd *SCpnt)
| > +{
| > +	return FAILED;
| > +}
| > +
| > +static int BusLogic_bus_reset(Scsi_Cmnd *SCpnt)
| > +{
| > +	return FAILED;
| > +}
| > +
| > +static int BusLogic_device_reset(Scsi_Cmnd *SCpnt)
| > +{
| > +	return FAILED;
| > +}
| > +
| 
| If the functions are just going to return FAILED you may want to
| consider leaving them out. Having these functions return fail will cause
| the output to be noisy. Either with this noisy output or not the
| recovery will end up at BusLogic_host_reset.

Yes, I noticed that (later).  I'll be glad to remove them.

This was the result of cut-and-paste from another driver.

Thanks.
--
~Randy
