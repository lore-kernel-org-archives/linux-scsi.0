From: Jan Merka <jm@wo.cz>
Subject: Re: Kernel 2.6.12x breaks the qlaxxxx driver
Date: Tue, 28 Jun 2005 12:56:51 -0400
Message-ID: <200506281256.51255.jm@wo.cz>
References: <200506272359.j5RNxBg26526@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost2.gsfc.nasa.gov ([128.183.244.130]:1413 "EHLO
	mailhost2.gsfc.nasa.gov") by vger.kernel.org with ESMTP
	id S262151AbVF1Q5G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 12:57:06 -0400
In-Reply-To: <200506272359.j5RNxBg26526@unix-os.sc.intel.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

On Monday 27 June 2005 07:59 pm, Chen, Kenneth W wrote:
> Jan Merka wrote on Monday, June 27, 2005 3:17 PM
>
> > The 2.6.12 and 2.6.12.1 kernels break the qlaxxxx driver(s).
>
> I thought someone on this list said it is fixed in 2.6.12.1.  I guess it
> is not.  I had the same problem last week and applying this patch works
> for me.
>
> http://marc.theaimsgroup.com/?l=linux-scsi&m=111836291000433&w=2

Thank you very much for the patch. The driver works now.

Jan
