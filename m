From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH v3 sent again] introduce soft reset handler
Date: Fri, 6 Feb 2009 13:57:58 +0100
Message-ID: <200902061358.00067.bs@q-leap.de>
References: <B73941C4DE6A3D4EA1AE128E9565E24423A0C8B613@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:50231 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZBFM6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 07:58:07 -0500
In-Reply-To: <B73941C4DE6A3D4EA1AE128E9565E24423A0C8B613@inbmail01.lsi.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, Andrew Morton <akpm@linux-foundation.org>

Sathya,

On Friday 06 February 2009 08:04:24 Prakash, Sathya wrote:
> Bernd,
> I think, there are certain other areas which needs fix up.  For example you
> have added the ioc_reset_in_progress flag in the MPT_ADAPTER and used it 
> instead of diagPending. But the diagPending is not removed from MPT_ADAPTER
> structure and hence there is possibility for that variable getting refered
> in other places whereas it is not getting set in the HardResetHandler So
> remove the variable from MPT_ADAPTER and solve the compile errors by
> replacing the diagPending with ioc_reset_in_progress. You can refer LSI
> code you have. Thanks
> Sathya

hmm, actually I thought diagPending and ioc_reset_in_progress are two 
different issues. But so it just seems to be a renaming. So I made an extra 
patch for that. I also noticed (already before), that in the your 4.x driver 
it doesn check in the reset handler for ioc->alt_ioc->ioc_reset_in_progress. 
Did this accidentaly happen or on purpose?


Thanks,
Bernd



-- 
Bernd Schubert
Q-Leap Networks GmbH
