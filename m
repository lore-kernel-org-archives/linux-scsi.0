From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 21:58:00 +0100
Message-ID: <1109710680.6293.164.camel@laptopd505.fenrus.org>
References: <OF551AE89E.73361D54-ON88256FB7.00720071-88256FB7.0072B239@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:33683 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261170AbVCAU6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 15:58:18 -0500
In-Reply-To: <OF551AE89E.73361D54-ON88256FB7.00720071-88256FB7.0072B239@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, 2005-03-01 at 12:53 -0800, Bryan Henderson wrote:
> >You want to *use* the kernel pagecache as much as you can.
> 
> No, I really don't.  Not always.  I can think of only 2 reasons to 
> maximize my use of the kernel pagecache: 1) saves me duplicating code; 2) 
> allows me to share resources (memory and disk bandwidth come to mind) with 
> others in the same Linux system fairly.  There are many cases where those 
> two benefits are outweighed by the benefits of using some other cache.  If 
> you're thinking of other benefits of using the pagecache, let's hear them.

The page cache is capable of using more ram than apps can on some
architectures. The page cache knows about numa and other topologic
issues. For IO the pagecache has highly tuned algorithms in the 2.6
kernel that throttle write out based on per spindle congestion (assuming
DM/MD raid). You can implement most of that yourself, sure. But why
duplicate and tune it for all those different systems out there if the
kernel already did that work


