From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/9] mpt2sas: Update driver to MPI2 REV K headers.
Date: Thu, 24 Sep 2009 18:39:43 +0000
Message-ID: <1253817583.5183.88.camel@mulgrave.site>
References: <20090914052934.GC31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53266 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbZIXSjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 14:39:43 -0400
In-Reply-To: <20090914052934.GC31450@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Mon, 2009-09-14 at 10:59 +0530, Kashyap, Desai wrote:
> @@ -3818,6 +3824,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
>         struct _sas_node *sas_expander;
>         unsigned long flags;
>         u8 link_rate_;
> +       Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;

This causes an unused variable warning when logging is disabled.

James


