From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Wed, 7 May 2014 19:12:31 +0000
Message-ID: <1399489950.2227.63.camel@dabdike.int.hansenpartnership.com>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
	 <20140507134757.GC12826@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:55955 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaEGTMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 15:12:38 -0400
In-Reply-To: <20140507134757.GC12826@phenom.dumpdata.com>
Content-Language: en-US
Content-ID: <50EE55463E914646A380A6D17E543F68@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "konrad@kernel.org" <konrad@kernel.org>, "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "pjones@redhat.com" <pjones@redhat.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>

On Wed, 2014-05-07 at 09:47 -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 07, 2014 at 05:00:20AM -0400, vikas.chaudhary@qlogic.com wrote:
> > From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> > 
> > Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".
> 
> Why? If it uses the standard iBFT format why does it use
> a non-standard signature?

This is useful as an academic exercise (and perhaps even a reminder to
broadcom not to do it again) but I don't think we can make it a show
stopper.  The boards have shipped with the non-standard signature, so we
have to work with them.

James

