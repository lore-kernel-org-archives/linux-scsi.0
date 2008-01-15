From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [Bugme-new] [Bug 9752] New: getting "FAULT code" message at startup in mpt fusion scsi driver
Date: Tue, 15 Jan 2008 14:08:03 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70C5D2CE@NAMAIL4.ad.lsil.com>
References: <20080115123715.d7d8de7e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35292 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbYAOVJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 16:09:20 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20080115123715.d7d8de7e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, cfriesen@nortel.com

On Tuesday, January 15, 2008 1:37 PM, Andrew Morton wrote:
> > On blade startup we're seeing the following message:
> > 
> > Fusion MPT base driver 3.02.55
> > Copyright (c) 1999-2005 LSI Logic Corporation
> > Fusion MPT SAS Host driver 3.02.55
> > mptbase: Initiating ioc0 bringup
> > mptbase: ioc0: WARNING - IOC is in FAULT state!!!
> >             FAULT code = 1804h
> > mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=0
> > mptbase: ioc0 NOT READY WARNING!
> > mptbase: WARNING - ioc0 did not initialize properly! (-1)
> > mptsas: probe of 0000:05:01.0 failed with error -1
> > 

What is happening is while the driver loading, the controller is in
FAULT_STATE, and we are unable to recover.  The FAULT_CODE = (0x1804) =
IFAULT_IOP_SELFTEST_FAILED_TIMER, means "Timer Failure".  I suggest this
customer try contacting LSI support channels. More than likely a
firmware upgrade might fix this issue.  I really doubt its a driver
issue. The channel support email id is support@lsi.com.  There maybe a
Notrel Product Marketing account manager, but I'm not for sure.

Eric




