From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 21:06:51 -0800
Message-ID: <499B976B.6010605@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B807B.2050509@kernel.org> <alpine.DEB.1.10.0902171935110.26625@asgard.lang.hm> <
 499B84CE.7090707@kernel.org> <alpine.DEB.1.10.0902172013230.26625@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:54314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZBRFHW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 00:07:22 -0500
In-Reply-To: <alpine.DEB.1.10.0902172013230.26625@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

david@lang.hm wrote:
> On Tue, 17 Feb 2009, Yinghai Lu wrote:
> 
>> please try two patches at the same time on 2.6.29-rc5.
>> don't apply other patch.
> 
> I did a git checkout -f HEAD then applied these two patches and the
> result works.
> 
but should have

pci 0000:80:10.0: Enabling HT MSI Mapping
pci 0000:80:11.0: Enabling HT MSI Mapping

because previous patch have
pci 0000:80:10.0: Found disabled HT MSI Mapping
pci 0000:80:10.0: MSI quirk detected; subordinate MSI disabled
pci 0000:80:11.0: Found disabled HT MSI Mapping
pci 0000:80:11.0: MSI quirk detected; subordinate MSI disabled

YH
