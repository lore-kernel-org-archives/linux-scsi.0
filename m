From: Andrew Morton <akpm@osdl.org>
Subject: Re: sym2 probs in current scsi bk
Date: Thu, 24 Jun 2004 21:14:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040624211432.156bc83d.akpm@osdl.org>
References: <20040624193311.6ea456c6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:48810 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266196AbUFYEP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 00:15:28 -0400
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i5P4FRZ22212
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2004 21:15:27 -0700
In-Reply-To: <20040624193311.6ea456c6.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew Morton <akpm@osdl.org> wrote:
>
> One of my test boxes has sym2, and it is now hanging during boot.

Please ignore - a separate patch had mucked up the interrupt routing.
