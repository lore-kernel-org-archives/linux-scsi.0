From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [LSF/MM TOPIC] Sparseness in storage
Date: Thu, 03 Feb 2011 09:40:25 -0500
Message-ID: <4D4ABE59.5010409@interlog.com>
References: <4D498F4B.3050207@interlog.com> <20110203022312.GA8529@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56783 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab1BCOka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2011 09:40:30 -0500
In-Reply-To: <20110203022312.GA8529@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11-02-02 09:23 PM, Christoph Hellwig wrote:
> On Wed, Feb 02, 2011 at 12:07:23PM -0500, Douglas Gilbert wrote:
>> are improving their sparseness handling as well, with Linux
>> playing "catch up" to NTFS in this regard (e.g. the new
>> FALLOC_FL_PUNCH_HOLE flag in fallocate() ).
>
> FYI: XFS has supported hole punching for more than 15 years, although
> the first years obviously were't on Linux.

I was looking at the Windows API yesterday and you need
to check each volume for sparse support. So it is file
system dependent there as well: VFAT doesn't support
sparseness and NTFS (version ?) does.

 From the perspective of user space tools, POSIX support
for sparseness would be helpful and FALLOC_FL_PUNCH_HOLE
looks like a step in that direction.

Doug Gilbert

