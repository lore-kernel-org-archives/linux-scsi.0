From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: What's the relation between libsas and scsi_transport_sas.c?
Date: Fri, 09 Nov 2007 12:33:12 -0800
Message-ID: <1194640392.3411.16.camel@localhost.localdomain>
References: <ac8af0be0711090126o4fc06572scd8e353cd1e1b694@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:35010 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761631AbXKJBDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 20:03:48 -0500
In-Reply-To: <ac8af0be0711090126o4fc06572scd8e353cd1e1b694@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-11-09 at 17:26 +0800, Zhao Forrest wrote:
> I found that libsas also reference to code of scsi_transport_sas.c.
> Will scsi_transport_sas.c be removed finally?
> If we add a new SAS LLDD to linux kernel, we should use libsas instead
> of the functions defined in scsi_transport_sas.c, right?

They're complimentary.  The transport class provides the topology and
service layers for all SAS hosts.  libsas provides additional helpers
and services for the actual protocol management needed on thinner
firmware cards like the aic94xx.  So, either you use scsi_transport_sas
only (for a fat firmware card) or you use both scsi_transport_sas and
libsas (for a thinner firmware card).

James


