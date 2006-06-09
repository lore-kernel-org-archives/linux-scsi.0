From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [patch 15/31] kdump: mpt fusion driver initialization failure fix
Date: Fri, 9 Jun 2006 10:23:29 -0400
Message-ID: <20060609142329.GA13620@in.ibm.com>
References: <200606090523.k595Nlcs032294@shell0.pdx.osdl.net> <1149862359.3480.2.camel@mulgrave.il.steeleye.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48263 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S965267AbWFIOXi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 10:23:38 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k59ENY83021782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Jun 2006 10:23:34 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k59ENRHV279722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Jun 2006 08:23:27 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k59ENXq0006221
	for <linux-scsi@vger.kernel.org>; Fri, 9 Jun 2006 08:23:33 -0600
Content-Disposition: inline
In-Reply-To: <1149862359.3480.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, Eric.Moore@lsil.com

On Fri, Jun 09, 2006 at 09:12:39AM -0500, James Bottomley wrote:
> On Thu, 2006-06-08 at 22:23 -0700, akpm@osdl.org wrote:
> > From: Vivek Goyal <vgoyal@in.ibm.com>
> > 
> > MPT fusion driver initialization fails while second kernel is booting,
> > after a system crash (if kdump kernel is configured).  Oops message is
> > pasted below.  I have attached a patch to fix the issue.  Your suggestions
> > are welcome.
> 
> This one's been in scsi-misc for quite a while ... is there some reason
> the normal processes didn't drop this?
>

Is a notification like email is generated upon inclusion of patch in
scsi-misc tree? I did not receive one and I was confused for quite some
time if patch is included or not.

Thanks
Vivek 
