From: Matthew Wilcox <willy@debian.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 13 Nov 2003 14:54:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113145423.GI10058@parcelfarce.linux.theplanet.co.uk>
References: <20031027153932.A16679@infradead.org> <008d01c3a9f2$a56e60c0$8f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:59624 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264321AbTKMPZV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 10:25:21 -0500
Content-Disposition: inline
In-Reply-To: <008d01c3a9f2$a56e60c0$8f074d0a@apac.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Thu, Nov 13, 2003 at 08:00:11PM +0530, Sachin Mhatre (smhatre) wrote:
> 	We need the md5 and crc functions from the user level as well as
> from the kernel. The crypto API and the CRC32 kernel  library functions
> can solve the problem of md5 and crc computation in the kernel. But its
> not possible to use these APIs from the user level. One way could be to
> use system calls. But wouldn't that make the code cumbersome?

Uhm, your user code is free to do whatever it likes, including using
its own md5 routines instead of the ones in libssl.  But the kernel code
should use the kernel facilities.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
