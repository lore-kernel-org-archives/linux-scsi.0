From: Steve Lord <lord@xfs.org>
Subject: Re: 3ware driver maximum request size
Date: Fri, 18 Aug 2006 14:08:55 -0500
Message-ID: <44E61047.1000007@xfs.org>
References: <44E4877F.2070708@xfs.org> <b1bc6a000608181146i65700723y7d5971bd891714af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail01hq.adic.com ([63.81.117.10]:35884 "EHLO MAIL01HQ.adic.com")
	by vger.kernel.org with ESMTP id S932120AbWHRTI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 15:08:56 -0400
In-Reply-To: <b1bc6a000608181146i65700723y7d5971bd891714af@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org

adam radford wrote:
> Steve,
> 
> It's capped at 128k per request because that is the max size the firmware
> was tested with.  If you increase that number, it is at your own risk, and
> you may have problems.
> 
> -Adam
> 

Thanks Adam,

It does seem capable of handling it under basic testing, guess I will take that
under advisement. So far the perf difference is not that large, so maybe it is
best left alone.

Steve
