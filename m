From: david@lang.hm
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 15:07:26 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm> <20090217230050.GG16841@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:52383 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZBQXHc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 18:07:32 -0500
In-Reply-To: <20090217230050.GG16841@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Tue, 17 Feb 2009, Matthew Wilcox wrote:

> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>> I got a picture of the failed boot at
>> http://linux.lang.hm/linux/IMG00052.jpg
>
> The PCI-MSI line is probably indicative.  Can you try booting with:
>
> mptbase.mpt_msi_enable_sas=0
>
> and also send us an lspci -v so we can update the blacklist?

is that disabling SAS for this system? if so, that's the wrong thing to do 
(the drives are SAS)

David Lang
