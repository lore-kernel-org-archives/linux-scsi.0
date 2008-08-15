From: "Dupuis, Chad" <Chad.Dupuis@hp.com>
Subject: RE: Setting target_can_queue from devinfo
Date: Fri, 15 Aug 2008 19:43:42 +0000
Message-ID: <A9035A2FF1FDD742A5AA440752E87AB33C4FA0A0A6@GVW0436EXB.americas.hpqcorp.net>
References: <D1D4C3FF75F9354393DB8314DF43DEF2E7F7E0@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:41158 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbYHOTof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 15:44:35 -0400
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F7E0@xbl3.emulex.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'James.Smart@Emulex.Com'" <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

It would probably help to merge the patches first.  It's sort of a "if you build it they will come" scenario.

--Chad

-----Original Message-----
From: James.Smart@Emulex.Com [mailto:James.Smart@Emulex.Com]
Sent: Tuesday, August 12, 2008 9:42 AM
To: Dupuis, Chad; linux-scsi@vger.kernel.org
Subject: RE: Setting target_can_queue from devinfo

Well, given the way the conversation ended, I assume the patch was ok, and James just needs to be prodded to include it into scsi-misc-2.6.
However, to make it useful, we need the entries for the different arrays to be posted as well.

-- james s

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dupuis, Chad
> Sent: Monday, August 11, 2008 4:23 PM
> To: linux-scsi@vger.kernel.org
> Subject: Setting target_can_queue from devinfo
>
> Hi All,
>
> Was there ever any more work done on this patchset:
> http://marc.info/?t=121070118300002&r=1&w=2?  None of the kernel git
> trees relating the scsi-misc seem to have this patchset applied.
>
> Thanks,
> Chad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
>
