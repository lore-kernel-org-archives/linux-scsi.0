From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v7 PATCH 0/4] bnx2fc: Broadcom FCoE offload driver submission
Date: Fri, 04 Feb 2011 14:27:31 -0600
Message-ID: <4D4C6133.4050205@cs.wisc.edu>
References: <1296850232.268.908.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33149 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab1BDU1H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2011 15:27:07 -0500
In-Reply-To: <1296850232.268.908.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>

On 02/04/2011 02:10 PM, Bhanu Gollapudi wrote:
> This is the v7 submission of Broadcom FCoE offload driver(bnx2fc)
> to the upstream kernel. This driver is for Broadcom Netxtreme II 57712
> chip. The following patches contain the driver sources for bnx2fc driver,
> and the libfc/libfcoe changes to enable bnx2fc. bnx2fc is a SCSI low level
> driver that interfaces with SCSI midlayer, libfc, libfcoe, cnic modules.
> bnx2fc driver uses services of libfc for slow path operations such as FIP and
> fabric discovery. The fast path IO perations are performed after offloading
> the session information to the underlying FCoE firmware.
>

Seems ok for merging. Thanks for putting up with all my crap :) At least 
I did find some real bugs too :) Thanks for your work on this.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
