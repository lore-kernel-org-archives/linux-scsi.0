From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH 10/13] iscsi-target: Add iSCSI Error Recovery Hierarchy support
Date: Thu, 28 Jul 2011 13:42:11 +0200
Message-ID: <CAJAFBLCgOeqnrPae+GQyjnoOUkF632Nrn4Bh-3d4K3KXCezbqw@mail.gmail.com>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	<1311410747-29947-11-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311410747-29947-11-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 23, 2011 at 10:45 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This patch adds support for RFC-3720 compatiable ErrorRecoveryLevel
> support as defined in Section 6.1.5. =A0Error Recovery Hierarchy.
>
> This includes support for iSCSI session reinstatement, iSCSI within
> command and within connection recovery, and explict/implict connectio=
n
> recovery (CSM-E and CSM-I) from state machines in Section 7 of RFC-37=
20.
>
> These functions are called from iscsi_target.c to handle processing
> based on the negotiated session-wide ErrorRecoveryLevel parameter.
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

This is interesting. Is ERL2 similar to md ? If so, when should I use
md and when ERL2 ?

Thanks,

=46ubo.
