From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] add two SCSI command opcodes
Date: Thu, 19 Apr 2007 10:49:53 -0600
Message-ID: <20070419164952.GA19438@parisc-linux.org>
References: <20070419151053.GA10199@localdomain> <20070419154743.GA18325@lug-owl.de> <20070419163959.GA25595@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38653 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766868AbXDSQty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 12:49:54 -0400
Content-Disposition: inline
In-Reply-To: <20070419163959.GA25595@localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, Apr 19, 2007 at 07:39:59PM +0300, Dan Aloni wrote:
> On Thu, Apr 19, 2007 at 05:47:43PM +0200, Jan-Benedict Glaw wrote:
> > Where's the user?
> 
> A privately maintained kernel driver.
> 
> Do we _must_ have in-tree users? I'd consider the change for completion's
> sake.

I agree with Dan -- if they're published in a SCSI spec, we should
include them in this header file.
