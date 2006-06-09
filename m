From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 15/31] kdump: mpt fusion driver initialization failure
	fix
Date: Fri, 09 Jun 2006 09:12:39 -0500
Message-ID: <1149862359.3480.2.camel@mulgrave.il.steeleye.com>
References: <200606090523.k595Nlcs032294@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57305 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965195AbWFIOMr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 10:12:47 -0400
In-Reply-To: <200606090523.k595Nlcs032294@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, vgoyal@in.ibm.com, Eric.Moore@lsil.com

On Thu, 2006-06-08 at 22:23 -0700, akpm@osdl.org wrote:
> From: Vivek Goyal <vgoyal@in.ibm.com>
> 
> MPT fusion driver initialization fails while second kernel is booting,
> after a system crash (if kdump kernel is configured).  Oops message is
> pasted below.  I have attached a patch to fix the issue.  Your suggestions
> are welcome.

This one's been in scsi-misc for quite a while ... is there some reason
the normal processes didn't drop this?

James


