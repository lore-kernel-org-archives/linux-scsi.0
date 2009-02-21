From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Fri, 20 Feb 2009 23:50:31 -0800
Message-ID: <m1fxi82pq0.fsf@fess.ebiederm.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	<alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>
	<20090217230050.GG16841@parisc-linux.org>
	<alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
	<86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
	<alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm>
	<499B46B2.5040601@kernel.org>
	<alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>
	<499B6BF7.9090300@kernel.org>
	<alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
	<499B724A.2040408@kernel.org>
	<alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
	<alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
	<499B774C.5010705@kernel.org>
	<alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
	<499B9129.50104@kernel.org> <499CD466.1060900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:40671 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZBUHuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2009 02:50:19 -0500
In-Reply-To: <499CD466.1060900@gmail.com> (Robert Hancock's message of "Wed\, 18 Feb 2009 21\:39\:18 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:
>
> Is there a reason why we can't just enable the HT MSI mapping for any bridge
> device that has that PCI capability and is underneath an HT bridge?

The code should be under CONFIG_X86 because the rules for enabling HT MSI mappings
are different for other architectures.  But otherwise I can't think of a reason.

> Essentially
> the code for nv_msi_ht_cap_quirk could potentially be applied to all bridges as
> it is currently for NVIDIA and ALi bridges..

Sounds like it would save a fair amount of grief.

Eric
