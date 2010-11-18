From: Sonny Rao <sonnyrao@us.ibm.com>
Subject: Re: [PATCH] [RFC] qla2xxx: Change parameter permissions in sysfs
Date: Thu, 18 Nov 2010 13:51:17 -0600
Message-ID: <20101118195117.GQ32203@us.ibm.com>
References: <1290078346-3521-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
 <5E4F49720D0BAD499EE1F01232234BA872242EF99D@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:41191 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0KRTvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 14:51:41 -0500
Content-Disposition: inline
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA872242EF99D@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Carnuccio <joe.carnuccio@qlogic.com>
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Milton Miller <miltonm@bga.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Driver <Linux-Driver@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Nov 18, 2010 at 11:33:12AM -0800, Joe Carnuccio wrote:
> Sonny,
> 
> The qla2xxx parameters that already had write permission do not require rebinding.
> 
> The qla2xxx parameters that require rebinding have read only permission and do not require write persmission since these are the ones whose value can be set on driver load.
> 
> The fact that some of the qla2xxx parameters had permission set to S_IRUGO|S_IRUSR was a "typo", it should have been S_IRUGO only, I have been in the process of addressing this in our drivers (here at QLogic).
> 
> Thanks.
> 
> -Joe

Ok thanks for clearing that up

Sonny
