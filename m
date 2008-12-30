From: Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Tue, 30 Dec 2008 16:35:39 -0500
Message-ID: <1230672939.24770.0.camel@localhost.localdomain>
References: <20081211210917.GB27010@uranus.ravnborg.org>
	 <4942BA85.3070408@vlnb.net>
	 <1229118607.24995.18.camel@localhost.localdomain>
	 <4943CAAB.4050008@vlnb.net>
	 <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
	 <494A37E9.5000009@vlnb.net>
	 <c62985530812200506u647fc135wcc818bc57d06cb04@mail.gmail.com>
	 <495137F4.9010404@vlnb.net> <20081227112055.GB18819@elte.hu>
	 <495A56A8.1030208@vlnb.net>  <20081230210303.GB6151@nowhere>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55523 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbYL3Vla (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2008 16:41:30 -0500
In-Reply-To: <20081230210303.GB6151@nowhere>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


On Tue, 2008-12-30 at 22:03 +0100, Frederic Weisbecker wrote:

> 
> > 2. If possible, make the view more compact, i.e. with less spaces on  
> > each line. Our tracing lines can be quite long.
> >
> > Thanks,
> > Vlad
> >
> 
> I'm not sure... The spaces are mostly here to keep fixed width columns, 
> in case we have huge durations, or long cmdlines...
> 

I agree. The spaces can easily be chopped with any one of many shell
scripts.

-- Steve


