From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: ahc_linux_map_seg() compile/style/data corruption fixes
Date: Tue, 13 May 2003 22:46:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514054625.GF2444@holomorphy.com>
References: <20030514044934.GC29926@holomorphy.com> <20030514053747.GE2444@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from holomorphy.com ([66.224.33.161]:44736 "EHLO holomorphy")
	by vger.kernel.org with ESMTP id S261808AbTENFdn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 01:33:43 -0400
Content-Disposition: inline
In-Reply-To: <20030514053747.GE2444@holomorphy.com>
List-Id: linux-scsi@vger.kernel.org
To: gibbs@scsiguy.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, May 13, 2003 at 10:37:47PM -0700, William Lee Irwin III wrote:
> Hmm, 2.5.x is supposed to guarantee most (if not all) of the
> preconditions the code here is trying to (re)establish. Probably the
> only use of not ripping out the 4GB spanning code and segment count
> checks is to keep driver versions synched. As it stands, this doesn't
> compile and if ever invoked the code not needed for 2.5 will not behave
> as expected (though thankfully a nop). Maybe a (shudder) #ifdef to rip
> out the overhead for 2.5 should be added esp. as post gcc-3.0 probably
> can't compile earlier kernels anyway.

Clarification: the code before my patch doesn't compile with gcc-3.3;
the code after it does. Mutatis mutandis with respect to the unexpected
behavior.


-- wli
