From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 1 Mar 2005 12:53:17 -0800
Message-ID: <OF551AE89E.73361D54-ON88256FB7.00720071-88256FB7.0072B239@us.ibm.com>
References: <1109702227.6293.137.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42643 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262072AbVCAUxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 15:53:00 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j21KqxCl008535
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 15:52:59 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j21KqxT6225520
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 15:52:59 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j21KqwOS009434
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 15:52:59 -0500
In-Reply-To: <1109702227.6293.137.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

>You want to *use* the kernel pagecache as much as you can.

No, I really don't.  Not always.  I can think of only 2 reasons to 
maximize my use of the kernel pagecache: 1) saves me duplicating code; 2) 
allows me to share resources (memory and disk bandwidth come to mind) with 
others in the same Linux system fairly.  There are many cases where those 
two benefits are outweighed by the benefits of using some other cache.  If 
you're thinking of other benefits of using the pagecache, let's hear them.

