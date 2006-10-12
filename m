From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] SCSI/qla2xxx: handle sysfs errors
Date: Thu, 12 Oct 2006 13:20:38 -0400
Message-ID: <452E7966.7030206@garzik.org>
References: <20061012014538.GA12894@havoc.gtf.org> <20061012165734.GG3638@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34753 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751426AbWJLRUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 13:20:41 -0400
In-Reply-To: <20061012165734.GG3638@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>

Andrew Vasquez wrote:
> NACK, please don't do this.  SYSFS entries, albiet important, aren't
> necessarilly critical to a functioning driver.  I'd rather the driver
> not error out.

As discussed before, the only errors thrown are either ENOMEM or EFAULT, 
both of which are quite serious.


> Here's what I had stewing to address the must_check directives and
> qla2xxx:

If you're gonna change it that much, might as well use attribute groups.

	Jeff


