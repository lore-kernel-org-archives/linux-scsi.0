From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 08/13] sg: nopage
Date: Tue, 5 Feb 2008 00:34:42 -0800
Message-ID: <20080205003442.0e057e62.akpm@linux-foundation.org>
References: <200802050753.m157r2m7010715@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290AbYBEIec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 03:34:32 -0500
In-Reply-To: <200802050753.m157r2m7010715@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, npiggin@suse.de, James.Bottomley@steeleye.com, dougg@torque.net

On Mon, 04 Feb 2008 23:53:21 -0800 akpm@linux-foundation.org wrote:

> From: Nick Piggin <npiggin@suse.de>
> 
> Convert SG from nopage to fault.
> 

Please give this some additional attention.  We'd like to remove 
vm_operations_struct.nopage() altogether and we can't do that while
it's hanging around in various subsystems.

Thanks.
