From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Wed, 2 Mar 2005 10:27:14 -0800
Message-ID: <OF05ADA43A.334E3B40-ON85256FB8.0064C44D-88256FB8.006505CD@us.ibm.com>
References: <1109711775.6293.169.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e6.ny.us.ibm.com ([32.97.182.146]:10887 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262414AbVCBS1R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2005 13:27:17 -0500
In-Reply-To: <1109711775.6293.169.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, mingz@ele.uri.edu

>except that in iscsi a big chunk of the access patterns are *external*;
>eg the real smarts are on that other machine on the network, not in the
>iscsi server. 

We strayed a little from the topic; I don't claim that a private 
user-space cache is better than the page cache for an ISCSI server.  My 
only point is that some of the reasons given for the kernel being a better 
place for ISCSI server code than user space are reasons only if you use 
assume using the page cache in both cases.

Of course, one can always argue first that the page cache is better for an 
ISCSI server than any other kind of cache, and therefore that the kernel 
is a better place than user space for the server code.  We just hadn't 
gone there yet.

--
Bryan Henderson                               San Jose California
IBM Almaden Research Center                   Filesystems
