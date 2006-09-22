From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 7180] New: aic94xx driver locks up on IBM x366 with Calgary IOMMU enabled
Date: Fri, 22 Sep 2006 09:05:04 +0300
Message-ID: <20060922060504.GD16501@rhun.haifa.ibm.com>
References: <20060921182350.55cb2816.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:58582 "EHLO
	mtagate5.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1751701AbWIVGFI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 02:05:08 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate5.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k8M657U2047340
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 06:05:07 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8M67MH81962236
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 07:07:22 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8M656I0001007
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 07:05:07 +0100
Content-Disposition: inline
In-Reply-To: <20060921182350.55cb2816.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Andi Kleen <ak@muc.de>, alexisb@us.ibm.com, djwong@us.ibm.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Jon Mason <jdmason@gmail.com>

On Thu, Sep 21, 2006 at 06:23:50PM -0700, Andrew Morton wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Thu, 21 Sep 2006 18:10:56 -0700
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 7180] New: aic94xx driver locks up on IBM
> x366 with Calgary IOMMU enabled
>
[snip]
>
> http://bugzilla.kernel.org/show_bug.cgi?id=7180

Thanks Andrew, we're looking into it.

Cheers,
Muli
