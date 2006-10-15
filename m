From: Douglas Gilbert <dougg@torque.net>
Subject: Re: About SG Elements of request_buffer
Date: Sun, 15 Oct 2006 11:40:16 -0400
Message-ID: <45325660.6070906@torque.net>
References: <453223AA.50409@aboo.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:23239 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751001AbWJOPiz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 11:38:55 -0400
In-Reply-To: <453223AA.50409@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> Hi All,
> 
> Thanks for all your support for my previous posts.
> 
> I have two questions.
> 
> 1. Is it safe to assume that all the SG elements of request_buffer are
> page aligned? (Except the first one and last one),  I mean, it is always
> multiple of pages?
> 
> 2. What are situations reading a scsi disk (using dd ) cause a write to
> the disk?  When I read my virtual scsi disk using dd command, block
> layer is generating lot of SCSI write, as well as reads. Any thoughts?
> Besides this observation, everything is working fine.

Aboo,
A comment on your second point: to bypass the vagaries of
the block layer caching with dd (or sg_dd) use 'iflag=direct'
and/or 'oflag=direct' as required. There may be alignment
constraints.

Doug Gilbert
