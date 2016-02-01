From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2] megaraid_sas: add an i/o barrier
Date: Mon, 1 Feb 2016 12:41:50 -0800
Message-ID: <20160201204150.GB18440@kroah.com>
References: <56AF67B4.2010702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42091 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932158AbcBAUlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 15:41:52 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 079D620B8A
	for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2016 15:41:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <56AF67B4.2010702@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>, "Desai, Kashyap" <Kashyap.Desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, stable@vger.kernel.org

On Mon, Feb 01, 2016 at 03:12:04PM +0100, Tomas Henzl wrote:
> A barrier should be added to ensure proper
> ordering of memory mapped writes.
> 
> V2: - added the barrier also to megasas_fire_cmd_skinny,
> as suggested by Kashyap Desai
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 1 +
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
>  2 files changed, 2 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
