From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 22:16:15 +0100
Message-ID: <1109711775.6293.169.camel@laptopd505.fenrus.org>
References: <OF961A122F.772A6491-ON88256FB7.0072D359-88256FB7.0073C3F8@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:63891 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262034AbVCAVQq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 16:16:46 -0500
In-Reply-To: <OF961A122F.772A6491-ON88256FB7.0072D359-88256FB7.0073C3F8@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: mingz@ele.uri.edu, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2005-03-01 at 13:04 -0800, Bryan Henderson wrote:
> >it is hard to beat linux kernel [page] cache performance though.
> 
> It's quite easy to beat it for particular applications.  You can use 
> special knowledge about the workload to drop pages that won't be accessed 
> soon in favor of pages that will, not clean a page that's just going to 
> get discarded or overwritten soon, allocate less space to less important 
> data, and on and on.

except that in iscsi a big chunk of the access patterns are *external*;
eg the real smarts are on that other machine on the network, not in the
iscsi server. 

(and some of the stuff you describe are available via the pagecache too
via madvise and friends)


