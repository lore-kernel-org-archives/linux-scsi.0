From: Steven Dake <sdake@mvista.com>
Subject: Re: adp94xx driver for 2.6.13?
Date: Wed, 31 Aug 2005 17:25:21 -0700
Message-ID: <1125534321.9169.43.camel@unnamed.az.mvista.com>
References: <20050831053318.GA3556@localhost.localdomain>
	 <1125518912.4617.41.camel@mulgrave>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:30818 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S965001AbVIAAZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 20:25:26 -0400
In-Reply-To: <1125518912.4617.41.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-08-31 at 16:08 -0400, James Bottomley wrote:
> On Tue, 2005-08-30 at 22:33 -0700, Ravikiran G Thirumalai wrote:
> > Are drivers/sources available for Adaptec's AIC-94XX SAS controllers
> > someplace?  I am trying to run 2.6.13 on a x460.  Any pointers to the latest
> > driver sources appreciated.
> 
> There is no driver source for Adaptec SATA hardware.  You need to get
> the latest binary drivers from Adaptec support.
> 
> James
> 
> 

James & Ravikiran,
Adaptec does have source code available under the GPL for the AIC 94xx.
In fact it was submitted to this list and rejected.

It appears to work reasonably well under our stress testing environments
here at mvista.  It does have some problems on x86_64 with 8gb of ram
but works well with 6gb on x86_64.  It also has a significant amount of
nits which make it unacceptable for kernel.org merging.

Regards
-steve
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

