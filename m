From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/17] Add ida and idr helper routines.
Date: Fri, 18 Sep 2015 11:49:08 -0400
Message-ID: <20150918154908.GA4065@mtj.duckdns.org>
References: <cover.1442263512.git.lduncan@suse.com>
 <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
 <20150915182755.GA31484@htj.duckdns.org>
 <1442342322.2177.13.camel@HansenPartnership.com>
 <20150915184157.GA495@htj.duckdns.org>
 <55FC30E2.8020000@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:35926 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbbIRPtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2015 11:49:12 -0400
Content-Disposition: inline
In-Reply-To: <55FC30E2.8020000@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>

Hello,

On Fri, Sep 18, 2015 at 08:42:26AM -0700, Lee Duncan wrote:
> To be clear: you would like a patch series that converts the users of
> the ida_* routines in my patches to instead use the ida_simple_*
> routines, correct? And of course the ida_* helper routines I was adding
> in idr.h would not be needed.

Yeap.

> If this is correct, I will supply a version 2 patch series that
> addresses this issue as well as the two patch-naming issues that were
> raised.

Sounds good to me.  If the shared lock blows up, we can make that
per-ida.

Thanks.

-- 
tejun
