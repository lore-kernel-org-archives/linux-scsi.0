From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
Date: Tue, 20 Mar 2007 12:01:22 -0400
Message-ID: <46000552.7010606@redhat.com>
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org> <45FFB867.3060500@prie.be> <200703201154.58234.olaf.kirch@oracle.com> <45FFE163.2050107@prie.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXCTQBw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2007 12:01:52 -0400
In-Reply-To: <45FFE163.2050107@prie.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefan@prie.be
Cc: Olaf Kirch <olaf.kirch@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

Stefan Priebe wrote:
> Hello!
> 
> With the sysrq i've found the function with is the problem:
> inode.c => nfs_getattr => nfs_sync_mapping_range
> 
> I've also found the attached patch - which is not included in any stable
> release nor in 2.6.21.X but is public since 20.02.07
> 
> I think this is very important.
> 

It is queued for 2.6.20.4.

