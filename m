From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] First round of SCSI updates for the 3.4+ merge window
Date: Mon, 21 May 2012 17:52:31 -0700
Message-ID: <CA+55aFz__YrXffza1bEzwrPu+-ETswUcg3F31Gjrj3OPbRyTZw@mail.gmail.com>
References: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39189 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab2EVAwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 20:52:53 -0400
In-Reply-To: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, May 21, 2012 at 4:30 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> The patch contains the usual assortment of driver updates (be2iscsi,
> bfa, bnx2i, fcoe, hpsa, isci, lpfc, megaraid, mpt2sas, pm8001, sg) pl=
us
> an assortment of other changes and fixes. =A0Also new is the fact tha=
t the
> isci update is delivered as a git merge (with signed tag).

Interesting. For some reason the 'gpg --verify' phase says that your
key has expired. Yet when I look at the key itself, it says it is
valid until 2016. I don't quite know why gpg thinks the thing is
expired when verifying the message.

But everything else looks fine. Somebody with more gpg-fu than me
might be able to clarify what is going on..

                  Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
