From: Greg KH <greg@kroah.com>
Subject: Re: s390 patches for 2.6.5.
Date: Thu, 8 Apr 2004 09:27:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408162758.GB9702@kroah.com>
References: <20040408142659.GA1793@mschwid3.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:13207 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262014AbUDHQ2l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 12:28:41 -0400
Content-Disposition: inline
In-Reply-To: <20040408142659.GA1793@mschwid3.boeblingen.de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 08, 2004 at 04:26:59PM +0200, Martin Schwidefsky wrote:
> I've included the zfcp patches in this patch set as well after I "fixed"
> the kfree problem. To get the other bug fixes into mainline I side-stepped
> the kfree issue. There are now release functions for the zfcp_unit and
> zfcp_port objects but I removed the module_exit function as well. Without
> the kfree trick we KNOW module unloading to be racy. So far we know of no
> other feasible solution for this problem. Therefore we removed the support
> for unloading of the zfcp module.

Thank you for fixing this.  I don't have a problem with this patch
anymore :)

greg k-h
