From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for kernel 4.1] Split SCSI header files
Date: Sun, 8 Mar 2015 17:12:06 +0100
Message-ID: <20150308161206.GA24616@lst.de>
References: <54ED8A71.3050701@sandisk.com> <20150305142635.GA17795@lst.de> <54F86F27.3000505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45401 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbbCHQML (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Mar 2015 12:12:11 -0400
Content-Disposition: inline
In-Reply-To: <54F86F27.3000505@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@parallels.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Mar 05, 2015 at 03:58:47PM +0100, Bart Van Assche wrote:
> Thanks for the review. Whether scsi_lun.h is separate or not is not
> important to me. The only reason I had proposed to create a separate
> header file for struct scsi_lun is because some other header files only
> need the definition of that structure and not any other definition that
> is present in the proposed scsi_proto.h header file.

Given how small and simple scsi_proto.h is that doesn't seem worth it to me.

> Creating a library of functions that are shared by initiator and target
> makes sense to me. Not only the LUN translation functions but also
> functions like scsi_command_size() are useful for both SCSI initiator
> and SCSI target code. If anyone has a suggestion for a good name for
> such a library that would be welcome. Unfortunately there is already a
> source file with the name scsi_lib.c in the kernel tree so using the
> name scsi_lib.h might be confusing.

scsi_common might be a good name for both the module and the header file.
