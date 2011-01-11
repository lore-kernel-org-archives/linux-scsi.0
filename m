From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: Re: [RFC PATCH v2 0/8] adding support to FCoE transport
Date: Mon, 10 Jan 2011 19:27:05 -0800
Message-ID: <1294716425.820.19.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
References: <20110107174027.14631.47077.stg.yi.zou@intel.com>
 <1294450430.4676.672.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2636 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab1AKD1P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 22:27:15 -0500
In-Reply-To: <1294450430.4676.672.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yi Zou <yi.zou@intel.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2011-01-07 at 17:33 -0800, Bhanu Gollapudi wrote:
> On Fri, 2011-01-07 at 09:42 -0800, Yi Zou wrote:
> > This is the RFC v2 of adding fcoe transport to support vendor specific FCoE
> > transport into the existing Open-FCoE framework.
> > 
> > v1:
> > Initial post for adding fcoe transport:
> > https://lists.open-fcoe.org/pipermail/devel/2010-December/010865.html
> > Follow-up comments & discussions:
> > https://lists.open-fcoe.org/pipermail/devel/2011-January/010890.html
> > 
> > v2:
> > 1. Per Joe's comment, renamed the libfcoe_fip.c to be fcoe_ctlr.c. I
> > also renamed the new ibfcoe_transport.c to be fcoe_transport.c.
> > 2. Per Bhanu's comment, I have merged the three follow-up patches
> > from Bhanu with the following changes in fcoe_parse_buffer():
> > a) Though not a problem of the existing fcoe-util since the sysfs
> > entry is changing to libfcoe anyway, I still want to fill the buffer
> > of drv_name with default "fcoe" so default behavior is still the same
> > w/o changing cfg-ethx.
> > b) Fixed the '\n' ending in the input buffer in fcoe_parse_buffer, we still
> > need that proper formatting logic from the original fcoe_if_to_netdev(),
> > otherwise the ifname and drv_name will be messed up, causing the lookup for
> > netdev and transport to fail.
> > 
> > Testing Notes:
> > Did the checkpatch and tested w/ overnight stress FCoE traffic on 2 LUNs using
> > fcoe.ko as the default fcoe transport, that seems to be working ok. However,
> > loop create/destroy testing is needed before this gets committed eventually.
> 
> Thanks Yi. bnx2fc patches got installed cleanly on top of your patches,
> and we were able run FCoE IO traffic, and will leave it running for the
> weekend.

Just to confirm IO stress tests over the weekend were successful.  I
submitted a couple of follow-up patches w.r.t ERESTARTSYS. 

Thanks,
Bhanu 


