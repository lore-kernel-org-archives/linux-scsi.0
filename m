From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Mon, 31 Mar 2008 12:39:32 -0700
Message-ID: <20080331123932.b0e515fb.akpm@linux-foundation.org>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
	<47F13CAF.1080707@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYCaTjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 15:39:48 -0400
In-Reply-To: <47F13CAF.1080707@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Mon, 31 Mar 2008 14:34:07 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> akpm@linux-foundation.org wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > __FUNCTION__ is gcc-specific, use __func__
> > 
> 
> 
> >  drivers/scsi/iscsi_tcp.c              |   12 +++---
> 
> I have some other patches which conflict with the iscsi bits. Could we 
> drop the iscsi parts from this patch, and I will send them with my other 
> updates for 2.6.26?

Sure - just make the changes which you want and when they turn up in
James's tree I'll drop them from that patch.

Maintaining this patch is bog-trivial - it's just a s/__FUNCTION__/__func__/
