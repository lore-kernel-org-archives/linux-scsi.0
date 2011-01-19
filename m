From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [v2 PATCH 5/5] bnx2fc: Broadcom FCoE Offload driver
 submission - part 3
Date: Wed, 19 Jan 2011 01:11:01 -0800
Message-ID: <C27F8246C663564A84BB7AB34397724240CE6BCB2F@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <1293170556.4676.575.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
 <4D350BF0.7040301@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4184 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1ASJLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2011 04:11:16 -0500
In-Reply-To: <4D350BF0.7040301@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, "Bhanu (Venkata Bhanu Prakash) Gollapudi" <bprakash@broadcom.com>
Cc: "'devel@open-fcoe.org'" <devel@open-fcoe.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Mike Christie wrote:

> 
> On 12/24/2010 12:02 AM, Bhanu Gollapudi wrote:
> > +++ b/drivers/scsi/bnx2fc/Kconfig
> > @@ -0,0 +1,11 @@
> > +config SCSI_BNX2X_FCOE
> > +	tristate "Broadcom NetXtreme II FCoE support"
> > +	depends on PCI
> > +	select NETDEVICES
> > +	select NETDEV_1000
> 
> 
> What is the NETDEV_1000 for?
> 
> 

We need NETDEV_1000 because cnic is under NETDEV_1000.  Kconfig
won't be able to check the dependencies correctly if we don't
select NETDEV_1000.

