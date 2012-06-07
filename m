From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: scsi: lpfc_scsi: Remove unused variables
Date: Thu, 7 Jun 2012 15:37:51 +0900
Message-ID: <20120607063751.GB16645@kroah.com>
References: <4FD0434B.7090405@gentoo.org>
 <20120607061255.GB3210@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37772 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab2FGGh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 02:37:58 -0400
Received: by pbbrp8 with SMTP id rp8so624120pbb.19
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jun 2012 23:37:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120607061255.GB3210@burratino>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Richard Yao <ryao@gentoo.org>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

On Thu, Jun 07, 2012 at 01:12:56AM -0500, Jonathan Nieder wrote:
> Hi Richard,
> 
> Richard Yao wrote:
> 
> > This is my first time patch submission. The commit message should
> > explain the issue.
> >
> > commit ba8c7a7a629b736fdc1abceaa3ec49f8820aec08
> > Author: Richard Yao <ryao@cs.stonybrook.edu>
> > Date:   Thu Jun 7 01:44:31 2012 -0400
> >
> >     scsi: lpfc_scsi: Remove unused variables
> >
> >     Kernels built with CONFIG_SCSI_LPFC fail to compile due to the use of
> >     -Werror=unused-variable. We solve that by removing some unused
> >     variables.
> 
> Wouldn't a saner fix be to stop using -Werror=unused-variable, or am I
> missing something subtle?

Yes, that is correct, older versions of gcc, and sometimes newer ones,
get this logic wrong and incorrectly flag variables that really are used
due to bugs in their detection logic.  Don't require a developer to have
a gcc version that is different from what the rest of the kernel
requires, as that is not allowed.

thanks,

greg k-h
