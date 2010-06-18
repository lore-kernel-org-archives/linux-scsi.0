From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 	Enable Online Controller Reset Bit in register related functions
Date: Fri, 18 Jun 2010 15:56:24 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09274EA@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	<AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	<4B6A08C587958942AA3002690DD4F8C3D09274C4@cosmail02.lsi.com>
 <AANLkTilNX7_IDjw5lFYpkzlGGPHeRsswWZCXslw5GsjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTilNX7_IDjw5lFYpkzlGGPHeRsswWZCXslw5GsjQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thanks, Yinghai.  It is possible James didn't push (patches 5-12) yet.

Regards,

Bo Yang

-----Original Message-----
From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of Yinghai Lu
Sent: Friday, June 18, 2010 5:37 PM
To: Yang, Bo
Cc: James.Bottomley@HansenPartnership.com; James.Bottomley@suse.de; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I: Enable Online Controller Reset Bit in register related functions

On Fri, Jun 18, 2010 at 2:21 PM, Yang, Bo <Bo.Yang@lsi.com> wrote:
> Yinghai,
>
> You need to apply patches 1/12 to 8/12 for this online controller reset (OCR) support.

current scsi-next only have

commit 6faad24ad989798475e9ab4a2a809008fff6e872
Author: Yang, Bo <Bo.Yang@lsi.com>
Date:   Wed Jun 9 20:34:43 2010 -0600

    [SCSI] megaraid_sas: Enable Online Controller Reset Bit in
register related functions


commit 4f3a268eca4e7073d315e7f9b0a4dc94a38da560
Author: Yang, Bo <Bo.Yang@lsi.com>
Date:   Wed Jun 9 20:51:48 2010 -0600

    [SCSI] megaraid_sas: Add the Chip reset functions to the driver

commit baf13c9440869a55d2493190dbc68c2bb165dad5
Author: Yang, Bo <Bo.Yang@lsi.com>
Date:   Wed Jun 9 20:59:43 2010 -0600

    [SCSI] megaraid_sas: add the reset function for Gen2 related chip

commit 449ee85225f9f41f2475f16b41d035000c8ee395
Author: Yang, Bo <Bo.Yang@lsi.com>
Date:   Wed Jun 9 21:25:17 2010 -0600

    [SCSI] megaraid_sas: return RESET in timeout routine



so looks like James didn't put
[PATCH 8/12] scsi: megaraid_sas - Online Controller Reset (OCR):
Driver re-issue the pending cmds to FW

in the tree yet.

or your patchset will break the bisecting?

Thanks

Yinghai
