From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Mon, 31 Mar 2008 14:34:07 -0500
Message-ID: <47F13CAF.1080707@cs.wisc.edu>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42963 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbYCaTex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 15:34:53 -0400
In-Reply-To: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> __FUNCTION__ is gcc-specific, use __func__
> 


>  drivers/scsi/iscsi_tcp.c              |   12 +++---

I have some other patches which conflict with the iscsi bits. Could we 
drop the iscsi parts from this patch, and I will send them with my other 
updates for 2.6.26?
