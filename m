From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target core updates for v3.1-rc1 (round 1)
Date: Sat, 23 Jul 2011 02:14:46 -0700
Message-ID: <1311412486.31450.238.camel@haakon2.linux-iscsi.org>
References: <1311326733.31450.120.camel@haakon2.linux-iscsi.org>
	 <CAJAFBLB8EiHmVJbLkQ7PWMfEcaxe1wv-e=2P7S8h2z7rTf-pew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45666 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1GWJYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 05:24:05 -0400
In-Reply-To: <CAJAFBLB8EiHmVJbLkQ7PWMfEcaxe1wv-e=2P7S8h2z7rTf-pew@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-iscsi-target-dev@googlegroups.com, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Madhu Iyengar <nkmi@yahoo.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Carpenter <error27@gmail.com>, Jesper Juhl <jj@chaosbits.net>, Stephen Rothwell <sfr@canb.auug.org.au>

On Sat, 2011-07-23 at 10:56 +0200, Fubo Chen wrote:
> On Fri, Jul 22, 2011 at 11:25 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >  target: Follow up core updates from AGrover and HCH (round 4)
> 
> i think this one introduces bug:
> 
> -       if (!(task->task_flags & TF_RUNNING))
> +       if (!task->task_flags & TF_RUNNING)
> 

Good catch here Fubo.  Committed as 710b05ea1a7a into lio-core-2.6.git,
and will get this included into a follow-up bugfixes pull for mainline.

Thanks!

--nab

