From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 1 Mar 2005 13:04:58 -0800
Message-ID: <OF961A122F.772A6491-ON88256FB7.0072D359-88256FB7.0073C3F8@us.ibm.com>
References: <1109702911.2878.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e2.ny.us.ibm.com ([32.97.182.142]:19346 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262068AbVCAVEj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 16:04:39 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j21L4c7t006376
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 16:04:38 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j21L4cT6191930
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 16:04:38 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j21L4bwL001157
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 16:04:38 -0500
In-Reply-To: <1109702911.2878.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Arjan van de Ven <arjan@infradead.org>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

>it is hard to beat linux kernel [page] cache performance though.

It's quite easy to beat it for particular applications.  You can use 
special knowledge about the workload to drop pages that won't be accessed 
soon in favor of pages that will, not clean a page that's just going to 
get discarded or overwritten soon, allocate less space to less important 
data, and on and on.

And that's pretty much the whole argument for direct I/O.  Sometimes the 
code above the filesystem layer is better at caching.

Of course, in this thread we're not talking about beating the page cache 
-- we're just talking about matching it, while reaping other benefits of 
user space code vs kernel code.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
