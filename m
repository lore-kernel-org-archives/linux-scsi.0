From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] FC transport: Allow LLDD to disable LUN scanning
Date: Wed, 22 Aug 2007 10:28:55 +0200
Message-ID: <20070822082854.GA4761@schmichrtp.de.ibm.com>
References: <20070821153716.GB11101@schmichrtp.de.ibm.com> <20070821154634.GA9163@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:15307 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXHVIbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2007 04:31:38 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l7M8VbYA106404
	for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 08:31:37 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7M8VbYo3047654
	for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 09:31:37 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7M8VNeR014955
	for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 09:31:24 +0100
Content-Disposition: inline
In-Reply-To: <20070821154634.GA9163@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>

On Tue, Aug 21, 2007 at 09:46:34AM -0600, Matthew Wilcox wrote:
> The comment exceeds 80 columns.  Why have a comment at all, none of the
> other fields here do, and it doesn't seem to add anything to me.

Agree. I will remove the comment.
