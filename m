From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] libsas: Provide a transport-level facility to request
 SAS addrs
Date: Tue, 19 Feb 2008 14:50:13 -0500
Message-ID: <47BB32F5.9010505@garzik.org>
References: <20080219184939.GB5414@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53507 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbYBSTuR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 14:50:17 -0500
In-Reply-To: <20080219184939.GB5414@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> Provide a facility to use the request_firmware() interface to get a SAS
> address from userspace.  This can be used by SAS LLDDs that cannot
> obtain the address from the host adapter.
> 
> Resend of 8 Oct. 2007 patch, now based off 2.6.25-rc2 + scsi_misc.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/libsas/sas_scsi_host.c |   41 +++++++++++++++++++++++++++++++++++
>  include/scsi/libsas.h               |    2 ++
>  2 files changed, 43 insertions(+), 0 deletions(-)

ACK patches 1-2


