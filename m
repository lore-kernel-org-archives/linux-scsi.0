From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
Date: Tue, 25 Oct 2011 11:48:45 +0200
Message-ID: <CA+55aFwk6CmHbVfV0eNPPdD4nmRJ_doGB1h6W4ywT-ZBprYR0w@mail.gmail.com>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
 <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com> <1319535924.18871.11.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35239 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab1JYJtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2011 05:49:15 -0400
In-Reply-To: <1319535924.18871.11.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>

On Tue, Oct 25, 2011 at 11:45 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> I don't believe so. =A0The diff-stat was generated using git-format-p=
atch
> from target-pending.git with git 1.5.6.5 from the following HEAD:

It might just be that you apparently have a rather old git version.
I'm rather more current, and some of the xdiff options have changed (I
think that 1.5.6 had the old "generate minimal diff" that got disabled
because it was very slow for some cases)

I am running git version 1.7.6.4.

             Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
