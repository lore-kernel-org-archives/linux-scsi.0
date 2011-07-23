From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [GIT PULL] target core updates for v3.1-rc1 (round 1)
Date: Sat, 23 Jul 2011 10:56:46 +0200
Message-ID: <CAJAFBLB8EiHmVJbLkQ7PWMfEcaxe1wv-e=2P7S8h2z7rTf-pew@mail.gmail.com>
References: <1311326733.31450.120.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46549 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1GWI4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 04:56:47 -0400
In-Reply-To: <1311326733.31450.120.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Madhu Iyengar <nkmi@yahoo.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Carpenter <error27@gmail.com>, Jesper Juhl <jj@chaosbits.net>, Stephen Rothwell <sfr@canb.auug.org.au>

On Fri, Jul 22, 2011 at 11:25 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> =A0target: Follow up core updates from AGrover and HCH (round 4)

i think this one introduces bug:

-       if (!(task->task_flags & TF_RUNNING))
+       if (!task->task_flags & TF_RUNNING)

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
