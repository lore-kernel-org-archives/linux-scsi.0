From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Advice on getting the scsi device name.
Date: Fri, 4 Jun 2004 09:09:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040604080935.GA28278@infradead.org>
References: <1086317300.1023.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:22175 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264368AbUFDIJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jun 2004 04:09:37 -0400
Content-Disposition: inline
In-Reply-To: <1086317300.1023.9.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Danny Leong <danny@trek2000.com.sg>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 04, 2004 at 10:48:16AM +0800, Danny Leong wrote:
> Hi, 
> 
>  I am writing a program that needs to safely and correctly identify and
> mount a dev/sda ... dev/sda1 or dev/sdb etc.As far my knowledge fits me,
> i have to manually check the entry on proc/scsi/scsi to determine.
> Please advice me on a better method that could be included in a C
> program. Any help is greatly appreciated. 

You can't.  mknod is done from userspace and the kernel can't gurantee
you the name.
