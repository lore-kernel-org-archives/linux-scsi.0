From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: SATA on mptsas performance
Date: Tue, 14 Feb 2006 09:02:22 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F28A5FF@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:979 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161090AbWBNQCY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 11:02:24 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>, linux-scsi@vger.kernel.org

On Monday, February 13, 2006 7:02 AM, Mirko Benz wrote:  
> 
> Hello,
> 
> We are testing the following setup:
> - LSI SAS3442X controller
> - Promise J300S SAS JBOD connected via the external port of the SAS 
> controller
> - 10 SATA disks (Seagate) in the JBOD
> - Linux kernel 2.6.16RC2 on a INTEL Dual Xeon Server, 2.8 
> Ghz, 64 bit mode
> 
> LSI SAS driver provided by the kernel finds the JBOD and the disks.

How many links are connected between your controller and the JBOD?
With that many drives, I suggest you connect four cables to create
a wide port.   There is a expander in your JBOD, right?  Meaning its
not a SATA port mulitplier?

> Single disk performance is like attaching via a SATA 
> controller from the 
> chipset.

Are your disks SATA-II, and do they support NCQ?  If so, I suggest
we enable that.   That is can be done in the NVDATA.

> Testing with multiple parallel drive accesses gives very poor results 
> and high system utilisation.
> Tests performed with parallel invocations of dd with bs=32k. 
> Values in MB/s.
> 

Which benchmarking tool are you using?

