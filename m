From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 05:21:37 -0700
Message-ID: <20090218122137.GJ16841@parisc-linux.org>
References: <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60726 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZBRMVz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Feb 2009 07:21:55 -0500
Content-Disposition: inline
In-Reply-To: <499B9129.50104@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
> 
> Impact: workaround BIOS that doesn't enable that bit
> 
> David reported that LSI sas doesn't work with MSI.
> it turns out that BIOS doesn't enable HT MSI
> 8132 does support HT MSI.
> add quirk to enable it
> 
> Reported-by: David Lang <david@lang.hm>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

Jesse, I think this should go into Linus' tree sooner rather than later.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
