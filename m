From: Christoph Hellwig <hch@infradead.org>
Subject: Re: the problem about a320raid driver
Date: Tue, 18 Jan 2005 09:40:38 +0000
Message-ID: <20050118094038.GA25004@infradead.org>
References: <389C46D66D1FEC4FA5B03A781A29580B802F0F@mailserver.sz.webex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:13291 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261209AbVARJkj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 04:40:39 -0500
Content-Disposition: inline
In-Reply-To: <389C46D66D1FEC4FA5B03A781A29580B802F0F@mailserver.sz.webex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Cai <richardc@sz.webex.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 18, 2005 at 05:39:03PM +0800, Richard Cai wrote:
> Hi
>    I am using intel SE7501WV2 server, with a AIC 7902(A) SCSI control , a320raid driver. OS is redhat 8.0 , kernel is 2.4.18-14. if I run lsmod, it showes the a320raid module is right. Now I want to recompile to kernel , but every time when I run the command make install, it will prompt : "No module a320raid found for kernel 2.4.18-14custom " . Who can lead me a right way ? thanks. 

There's never been an a320raid module in the kernel tree.  Try to find out
where you got it from and ask them for the driver source.

