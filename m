From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Wed, 2 Mar 2005 13:20:24 -0500
Message-ID: <OF28B4EEEA.0271C53B-ON85256FB8.0064150B-88256FB8.00646550@us.ibm.com>
References: <1109711714.2878.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e4.ny.us.ibm.com ([32.97.182.144]:65438 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262425AbVCBSUf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2005 13:20:35 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j22IKVsv021556
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 13:20:31 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j22IKVLP050388
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 13:20:31 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j22IKUCD004590
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 13:20:31 -0500
In-Reply-To: <1109711714.2878.72.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Arjan van de Ven <arjan@infradead.org>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

>u are talking about application aware caching/prefetching stuff. but i
>prefer to modifying kernel page cache a little bit while make use of
>most of the code there.

That's a powerful argument for using the page cache, and further, for 
using it from within the kernel.  I once started a project to port a 
particular filesystem driver from the kernel to user space.  It was to be 
used in a Linux system whose sole purpose was to export one filesystem via 
NFS.  I was looking for engineering ease.  Everything about porting the 
driver to user space was almost trivial except for duplicating the page 
cache, and that was enough work to call into question the whole strategy 
(I never went far enough to actually make a decision).

But I'm sure there are cases where the tradeoff works.

--
Bryan Henderson                               San Jose California
IBM Almaden Research Center                   Filesystems
