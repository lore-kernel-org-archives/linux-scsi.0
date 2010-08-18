From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Wed, 18 Aug 2010 17:30:33 +0200
Message-ID: <AANLkTinARwxMat+YA0XsKTozdvh5Tta8_CDhZ8bM-NMa@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTimJGxn=5kEMH68XVWqFcYG3vpfLjLjZpFGqhG_4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58486 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0HRPaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2010 11:30:39 -0400
In-Reply-To: <AANLkTimJGxn=5kEMH68XVWqFcYG3vpfLjLjZpFGqhG_4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chetan Loke <generationgnu@yahoo.com>, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 18, 2010 at 5:11 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> On Wed, 2010-08-18 at 07:58 -0700, Chetan Loke wrote:
> > [ ... ]
> >
> > During the open panel, my question was really specific -
> >
> > Q) What is the future of a SCSI-target subsystem in linux. Which
> > =A0 =A0target engine/subsystem can we expect?
> >
> > Your answer) There is place for only 1 target-subsystem in the Linu=
x
> > scsi stack and in the LSF summit the decision was taken to merge LI=
O.
> > Has that
> > decision changed since the summit?
>
> The decision hasn't been taken to merge LIO, but based on what happen=
ed
> at the summit, I think it's the most viable candidate and will likely=
 be
> merged by 2.6.37

(resending as plain text)

No matter which kernel-based storage target subsystem is merged, a
migration path should be provided for SCST users such that these can
continue using their SCST target drivers without too much trouble.
Otherwise you'll upset a large number of SCST users.

Note: an SCST target driver is the code that implements a storage
protocol. See also http://scst.sourceforge.net/scst_pg.html for a
overview diagram.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
