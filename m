From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Sun, 10 Sep 2006 07:56:31 -0600
Message-ID: <20060910135631.GD29775@parisc-linux.org>
References: <20060909210856.GC21263@stat.unipd.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:14017 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S932158AbWIJN4c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Sep 2006 09:56:32 -0400
Content-Disposition: inline
In-Reply-To: <20060909210856.GC21263@stat.unipd.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mmzz@stat.unipd.it, linux-scsi@vger.kernel.org

On Sat, Sep 09, 2006 at 11:08:56PM +0200, Alberto Cammozzo wrote:
> It's the first time I use this setup... Am I missing something?
> 
> lsmod:
> Module                  Size  Used by
> lpfc                  145600  0 
> scsi_transport_fc      25568  1 lpfc
> iscsi_tcp              19808  1 
> libiscsi               17504  1 iscsi_tcp
> scsi_transport_iscsi    23244  3 iscsi_tcp,libiscsi
> skge                   31312  0 
> [...]

does the [...] include sd_mod (or sd?  i forget what it's called)
