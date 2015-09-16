From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 01/30] cxlflash: Fix to avoid invalid port_sel value
Date: Wed, 16 Sep 2015 16:09:29 -0500
Message-ID: <C47C20BA-B972-4193-950C-07A4A547503A@linux.vnet.ibm.com>
References: <1442422317-40957-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442431127.2234.28.camel@HansenPartnership.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:47358 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbbIPVJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 17:09:37 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 17:09:37 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 60FC7C9003C
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:00:38 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GL9Yru44433412
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 21:09:34 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GL9VGw017784
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:09:34 -0400
In-Reply-To: <1442431127.2234.28.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com, mikey@neuling.org, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <kumarmn@us.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 16, 2015, at 2:18 PM, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> Could you please add a cover letter (a 0/30) and thread your patches
> from that?  For large patch series, it really does make following
> everything a lot easier for me (and most other people who use a threaded
> mail reader).

James,

My mistake. I'll send out a properly threaded series shortly.


-matt
