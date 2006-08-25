From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [Announce] smp_utils-0.91 available
Date: Fri, 25 Aug 2006 14:45:40 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D702BD839@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:17623 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932459AbWHYUqD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 16:46:03 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi@vger.kernel.org

On Wednesday, August 23, 2006 8:11 AM, Douglas Gilbert wrote:

> Two interfaces are available: the "mptctl" pass through used
> by MPT Fusion SAS HBAs and the "smp_portal" sysfs attribute
> pass through used by at least one aic94xx based Linux driver.
> 

It doesn't seem to work when I have more than one fusion controller.
What is the command line option for passing the ioc number?

Eric Moore
