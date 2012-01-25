From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: READ CAPACITY(16) failed, failure in mpt2sas_transport_port_add
Date: Wed, 25 Jan 2012 18:37:29 +1030
Message-ID: <20120125080728.GA1957@tuon>
References: <20120125015725.GA2938@tuon>
 <A6888A6805518E4EA4AF7072A28264A6048BC1A2FE@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6475 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab2AYIKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 03:10:37 -0500
Content-Disposition: inline
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6048BC1A2FE@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jan 25, 2012 at 10:52:34AM +0530, Nandigama, Nagalakshmi wrote:
> Request to apply the attached patch and test.
>  scsi-misc-2[1].6.git-2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45.patch

Great, that fixes the issue!

Cheers,
Kevin.
