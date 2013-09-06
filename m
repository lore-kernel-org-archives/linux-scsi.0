From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ibmvscsi: Fix little endian issues
Date: Fri, 06 Sep 2013 11:38:52 -0700
Message-ID: <1378492732.2063.30.camel@dabdike.int.hansenpartnership.com>
References: <20130903100447.6ae7c7a2@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52008 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab3IFSiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 14:38:55 -0400
In-Reply-To: <20130903100447.6ae7c7a2@kryten>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: rcj@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Tue, 2013-09-03 at 10:04 +1000, Anton Blanchard wrote:
> The hypervisor is big endian, so little endian kernel builds need
> to byteswap.
>     
> Signed-off-by: Anton Blanchard <anton@samba.org>

You have two serious checkpatch errors in this:

ERROR: trailing whitespace
#57: FILE: drivers/scsi/ibmvscsi/ibmvscsi.c:469:
+^I^Ievt->crq.IU_data_ptr = cpu_to_be64(pool->iu_token + $

ERROR: do not use assignment in if condition
#128: FILE: drivers/scsi/ibmvscsi/ibmvscsi.c:926:
+       if ((rc = ibmvscsi_send_crq(hostdata,
be64_to_cpu(crq_as_u64[0]),




