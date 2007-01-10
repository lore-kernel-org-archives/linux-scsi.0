From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Tue, 9 Jan 2007 22:44:02 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70513031@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44500 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600AbXAJFoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2007 00:44:25 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Goggin <egoggin@vmware.com>, linux-scsi@vger.kernel.org
Cc: Adam Zimman <azimman@vmware.com>, Petr Vandrovec <petr@vmware.com>, dgreen@vmware.com, Manon Goo <manon@manon.de>, Michael Reed <mdr@sgi.com>, David Berghoff <david@dg-i.net>, Vicky Xu <vgxu@vmware.com>, James Bottomley <James.Bottomley@SteelEye.com>, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

On Tuesday, January 09, 2007 2:33 PM, Edward Goggin wrote: 

> multi-pathing.  This requirement shouldn't be a problem for the IBM
> RDAC/MPP driver either since it should already be setting the
> REQ_FAILFAST attribute of I/Os for which it is providing 
> multi-pathing,
> similar to what the Linux dm-multipath driver already does.
> 

This approach seems to be the best.   The other one from Petr is
good as well, however I've not had time today to verify whether 
this detection algorithm will work properly, as we have built pcie 1030
parts,
and its checking for pcix compatibilty at offset 0x68.

With regards to this patch, I need to contact the mpp folks to see
whether they are setting the REQ_FAILFAST attribute.   I will
followup shortly.

Eric 
