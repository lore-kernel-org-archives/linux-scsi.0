From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: 2.6.9-rc1-mm5 qlogic oops
Date: 13 Sep 2004 15:47:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095115675.3628.175.camel@dyn318077bld.beaverton.ibm.com>
References: <1095100546.3628.162.camel@dyn318077bld.beaverton.ibm.com>
	 <20040913212413.GA22149@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:21234 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S269043AbUIMWvm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 18:51:42 -0400
In-Reply-To: <20040913212413.GA22149@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

It worked. 

Thanks,
Badari

On Mon, 2004-09-13 at 14:24, Andrew Vasquez wrote:
> On Mon, 13 Sep 2004, Badari Pulavarty wrote:
> 
> > 
> > I get this Oops with qlogic 2200 FC controllers with 2.6.9-rc1-mm5.
> > Is this a known issue ? Any fixes ?
> > 
> 
> Hmm, there seems to be some merging problems in changeset 1.44 for
> qla_os.c -- the 'DMA pool/api usage' patch I sent is not completely
> integrated (appears to be massaging problems while attempting to apply
> on top off 1.43).
> 
> Please apply the attached patch which should address the issue.
> 
> Regards,
> Andrew Vasquez

