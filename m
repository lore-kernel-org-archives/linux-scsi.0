From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [PATCH] scsi_debug  v 1.75 for lk 2.6.9-bk4
Date: Mon, 25 Oct 2004 10:26:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041025172636.GC2209@us.ibm.com>
References: <4179B89B.8030207@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:42136 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261166AbUJYR0L
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 13:26:11 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id i9PHQ61p646724
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2004 13:26:06 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i9PHQ6qo437882
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2004 11:26:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id i9PHQ5Dg030376
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2004 11:26:05 -0600
Content-Disposition: inline
In-Reply-To: <4179B89B.8030207@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 23, 2004 at 11:49:15AM +1000, Douglas Gilbert wrote:
> This gzipped patch is against lk 2.6.9-bk4 which is
> after the lk 2.6.9 release and includes James's "[BK
> PATCH] SCSI updates for 2.6.9" omnibus patch.
> 
> The changelog is with respect to version 1.74 found
> in James's post lk 2.6.9 patch. The scsi_debug.[hc] files
> can be found in the sdebug175.tgz tarball at
> http://www.torque.net/sg/sdebug26.html
> 
> Nishanth, perhaps you could test this version and report
> if it works and if the data transfers still seem slow.

I will test the patch today and report my results, thanks.

-Nish
