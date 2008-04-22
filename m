From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [2.6 patch] scsi/qla2xxx/qla_os.c: make 2 functions static
Date: Tue, 22 Apr 2008 15:12:37 -0700
Message-ID: <20080422221237.GA80148@d8550avq18955.qlogic.org>
References: <20080421084942.GV26897@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39271 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699AbYDVWMi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 18:12:38 -0400
Content-Disposition: inline
In-Reply-To: <20080421084942.GV26897@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008, Adrian Bunk wrote:

> This patch makes the following needlessly global functions static:
> - qla2x00_alloc_work()
> - qla2x00_post_work()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks Adrian.  I'll add the two patches to my queue of qla2xxx
updates and submit the group shortly.

--
av
