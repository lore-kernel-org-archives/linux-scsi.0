From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] scsi: libfc add missing braces to in WARN_ON
Date: Thu, 19 Feb 2009 11:59:49 -0800
Message-ID: <1235073589.4377.6.camel@brick>
References: <1235072152.4377.4.camel@brick>
	 <1235073196.12500.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:22504 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZBST7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Feb 2009 14:59:52 -0500
Received: by an-out-0708.google.com with SMTP id c2so237046anc.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2009 11:59:51 -0800 (PST)
In-Reply-To: <1235073196.12500.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2009-02-19 at 19:53 +0000, James Bottomley wrote:
> On Thu, 2009-02-19 at 11:35 -0800, Harvey Harrison wrote:
> > Noticed by sparse:
> > drivers/scsi/libfc/fc_exch.c:286:3: warning: dubious: !x & y
> 
> Thanks for finding this, but the patch is already queued here:
> 
> http://marc.info/?l=linux-scsi&m=123378225922727
> 
> James
> 

No worries, just did a sparse run on linux-next (20090217) and saw this.

Harvey

