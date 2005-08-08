From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 16:25:15 -0400
Message-ID: <42F7BFAB.8020707@adaptec.com>
References: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org> <1123451837.5020.22.camel@mulgrave> <42F7A344.8070905@adaptec.com> <20050808195453.GA22773@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:60070 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932213AbVHHUZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 16:25:29 -0400
In-Reply-To: <20050808195453.GA22773@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/08/05 15:54, Mike Anderson wrote:
> I believe James suggestion of
> adding to scsi_host_dev_release would allow the LLDD to get a better
> indicator of release cleanup without changing the LLDD interface to use
> ksets.

Ah, yes, I completely agree.

	Luben
