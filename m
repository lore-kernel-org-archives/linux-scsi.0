From: Andrew Morton <akpm@osdl.org>
Subject: Re: Infinite retries reading the partition table
Date: Thu, 30 Nov 2006 21:47:16 -0800
Message-ID: <20061130214716.6306a586.akpm@osdl.org>
References: <617182.73467.qm@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:20378 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1758196AbWLAFrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2006 00:47:18 -0500
In-Reply-To: <617182.73467.qm@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 29 Nov 2006 17:22:48 -0800 (PST)
Luben Tuikov <ltuikov@yahoo.com> wrote:

> Suppose reading sector 0 always reports an error,
> sense key HARDWARE ERROR.
> 
> What I'm observing is that the request to read sector 0,
> reading partition information, is retried forever, ad infinitum.
> 
> Does anyone have a patch to resolve this? (2.6.19-rc6)
> 

Please send a backtrace so we can see where the offending loop occurs.
