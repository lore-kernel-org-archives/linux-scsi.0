From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC][PATCH]SCSI signal(I/O) failure causes no response
Date: Thu, 22 Apr 2004 21:44:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040423044436.GA881054@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E570442C1B2@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:54395 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S264717AbUDWEps (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 00:45:48 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570442C1B2@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Apr 14, 2004 at 11:56:20AM -0400, Moore, Eric Dean wrote:
> For this particular issue, Mr Masao Fukuchi has a
> scsi bus test analyzer, in which he set the C/D signal 
> to low during read operation.  The MPT firmware
> returned MPI_IOCSTATUS_SCSI_PROTOCAL_ERROR, which from
> the mpt manual means " An unrecoverable bus protocal error
> as terminated the SCSI I/O" and the driver will 
> return DID_RESET.
> 
> Here are some of the other cases which return
> DID_RESET, however I doubt were returned with 
> Mr Masao Fukuchi's test anaylzer:
> 
> MPI_IOCSTATUS_SCSI_TASK_TERMINATED
> MPI_IOCSTATUS_SCSI_IOC_TERMINATED
> MPI_IOCSTATUS_SCSI_EXT_TERMINATED


I think I would return DID_ERROR for things like that as a sort
of generic "something-went-wrong" on the SCSI bus.

jeremy
