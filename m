From: Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Fri, 20 May 2005 15:39:29 +0530
Message-ID: <20050520100928.GA3963@in.ibm.com>
References: <20050516085832.GA9558@gmail.com> <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org> <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com> <1116354894.4989.42.camel@mulgrave> <428C030E.8030102@cybsft.com> <1116476630.5867.2.camel@mulgrave> <20050519095143.GA3972@in.ibm.com> <1116546970.5037.137.camel@mulgrave>
Reply-To: dino@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:8943 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261394AbVETKAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2005 06:00:14 -0400
Content-Disposition: inline
In-Reply-To: <1116546970.5037.137.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "K.R. Foley" <kr@cybsft.com>, Andrew Morton <akpm@osdl.org>, gregoire.favre@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, May 19, 2005 at 06:56:10PM -0500, James Bottomley wrote:
> 
> OK, could you try this one (also against vanilla 2.6.12-rc4).  Hopefully
> it's a rollup of all the aic7xxx changes plus the necessary supporting
> infrastructure in my scsi-misc tree.
> 

This works fine for me with 2.6.12-rc4, Thanks

I would appreciate if you can send this to -mm too

	-Dinakar
