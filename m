From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Land iscsi iser performance patches to upstream
Date: Mon, 03 Jan 2011 16:32:27 -0600
Message-ID: <4D224E7B.5040704@cs.wisc.edu>
References: <20101216050257.GC1263@parisc-linux.org> <4D09AE7C.6070708@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57217 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1ACWcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2011 17:32:25 -0500
In-Reply-To: <4D09AE7C.6070708@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhiqi Tao <zhiqi.tao@oracle.com>
Cc: linux-scsi@vger.kernel.org, Or Gerlitz <ogerlitz@voltaire.com>

On 12/16/2010 12:15 AM, Zhiqi Tao wrote:
> Hi,
>
> Could anyone advise if there is any plan to push these patches to land
> the upstream?
>
> Patch 1/3
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg14533.html
> Patch 2/3
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg14381.html
> Patch 3/3
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg14398.html
>
>
> In particular patch 2 and 3 are matching the iscsi_tcp.c values and have
> improved the performance that we got. It will be beneficial to include
> them into the vanilla kernel.
>

Hey Or,

These patches look ok except for #1. Did you guys have some weird 
restrictions? Or did you have some weird restrictions but the iser 
driver handles it (see iser_data_buf_aligned_len related code). I think 
instead of 0 you want to set the dma alignment to 4K?
