From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: What's the relation between libsas and scsi_transport_sas.c?
Date: Tue, 13 Nov 2007 15:42:44 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70B3415F@NAMAIL4.ad.lsil.com>
References: <ac8af0be0711090126o4fc06572scd8e353cd1e1b694@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56317 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbXKMWms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 17:42:48 -0500
Content-class: urn:content-classes:message
In-Reply-To: <ac8af0be0711090126o4fc06572scd8e353cd1e1b694@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhao Forrest <forrest.zhao@gmail.com>, linux-scsi@vger.kernel.org

Zhao - mpt fusion uses scsi_transport_sas.c, not libsas.c.    The
scsi_transport_sas.c module can't be removed.    The libsas is for hbas
that have no firmware.

Eric

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Zhao Forrest
> Sent: Friday, November 09, 2007 2:27 AM
> To: linux-scsi@vger.kernel.org
> Subject: What's the relation between libsas and scsi_transport_sas.c?
> 
> I found that libsas also reference to code of scsi_transport_sas.c.
> Will scsi_transport_sas.c be removed finally?
> If we add a new SAS LLDD to linux kernel, we should use libsas instead
> of the functions defined in scsi_transport_sas.c, right?
> 
> Thanks,
> Forrest
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
