From: Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 26 May 2005 16:20:33 +0530
Message-ID: <20050526105033.GA6496@in.ibm.com>
References: <20050516085832.GA9558@gmail.com> <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org> <20050517083436.GB4794@in.ibm.com> <20050526003930.71bb14fb.akpm@osdl.org>
Reply-To: dino@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:9167 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261304AbVEZKmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 06:42:18 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4QAgINL024609
	for <linux-scsi@vger.kernel.org>; Thu, 26 May 2005 06:42:18 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4QAgH5Z156830
	for <linux-scsi@vger.kernel.org>; Thu, 26 May 2005 06:42:17 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4QAgHpL029002
	for <linux-scsi@vger.kernel.org>; Thu, 26 May 2005 06:42:17 -0400
Content-Disposition: inline
In-Reply-To: <20050526003930.71bb14fb.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: gregoire.favre@gmail.com, linux-scsi@vger.kernel.org

On Thu, May 26, 2005 at 12:39:30AM -0700, Andrew Morton wrote:
> 
> Gents, can you please confirm that 2.6.12-rc5 is working OK now?
> 

I checked 2.6.12-rc5 and 2.6.12-rc5-mm1 and SCSI comes up fine 
on both

Thanks James and Andrew

	-Dinakar
