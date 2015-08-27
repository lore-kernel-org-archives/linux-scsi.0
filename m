From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight
 mpt2sas
Date: Thu, 27 Aug 2015 07:40:14 -0700
Message-ID: <1440686414.2196.107.camel@HansenPartnership.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
	 <20150826235434.GA8843@mail.thefacebook.com>
	 <1440633514.31814.3.camel@haakon3.risingtidesystems.com>
	 <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52367 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbbH0OkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 10:40:17 -0400
In-Reply-To: <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Calvin Owens <calvinowens@fb.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team@fb.com

On Thu, 2015-08-27 at 10:37 +0530, Sreekanth Reddy wrote:
> HI Nicholas & Calvin,
> 
> Thanks for the patchset. Sure We will review and we do some unit
> testing on this patch series. Currently my bandwidth is occupied with
> some internal activity, so by end of next week I will acknowledge this
> series if all the thing are fine with this patch series.

Calvin responded to your review feedback and that series has been
outstanding for a while, so I'm not going to drop it from the misc tree.
However, I will reorder to make it ready for the second push. You have
until Friday week to find a problem with it.

James


