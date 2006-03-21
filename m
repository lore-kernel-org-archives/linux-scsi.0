From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: Question: where should the SCSI driver place MODE_SENSE data ?
Date: Tue, 21 Mar 2006 15:43:17 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265142117@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63906 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932460AbWCUWnU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Mar 2006 17:43:20 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@engenio.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Any comment on this question would be appreciated.
Thanks you, 

> -----Original Message-----
> From: Ju, Seokmann 
> Sent: Tuesday, March 21, 2006 11:45 AM
> To: 'James Bottomley'
> Cc: linux-scsi; linux-kernel
> Subject: Question: where should the SCSI driver place 
> MODE_SENSE data ?
> 
> In the 2.6 (2.6.9 and scsi-misc in git) kernel, MODE_SENSE 
> SCSI command packet (scsi_cmnd) carries following entries 
> with unexpectedly small in size.
> - request_bufflen
> - bufflen
> 
> Especially for MODE SENSE with page code 8 (caching page), 
> driver has minumum 12 Bytes MODE_SENSE data to deliver 
> besides 'mode parameter header' and 'block descriptors'.
> When I dump those entries, they both are 4 Bytes in size.
> To me, it seems like that SCSI mid layer allocated 512 Bytes 
> for MODE_SENSE data buffer, but the buffer length passed down 
> to LLD incorrectly.
> 
> Please guide me if there is anything missing.
> 
> Thank you,
> 
> Seokmann
