From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/9] mpt2sas: Update driver to MPI2 REV K headers.
Date: Fri, 25 Sep 2009 09:44:10 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8ECD8112@inbmail01.lsi.com>
References: <20090914052934.GC31450@lsi.com>,<1253817583.5183.88.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58672 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZIYEOP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2009 00:14:15 -0400
In-Reply-To: <1253817583.5183.88.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

My compilation environment  is always logging enabled.  Next time onwards I will perform both the combination before patch submission.
this variable usage should be under #define CONFIG_SCSI_MPT2SAS_LOGGING.

Shall I send complete patch set once again or only affected patch ?

Thanks,
Kashyap
________________________________________
From: James Bottomley [James.Bottomley@HansenPartnership.com]
Sent: Thursday, September 24, 2009 2:39 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 1/9] mpt2sas: Update driver to MPI2 REV K headers.

On Mon, 2009-09-14 at 10:59 +0530, Kashyap, Desai wrote:
> @@ -3818,6 +3824,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
>         struct _sas_node *sas_expander;
>         unsigned long flags;
>         u8 link_rate_;
> +       Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;

This causes an unused variable warning when logging is disabled.

James


