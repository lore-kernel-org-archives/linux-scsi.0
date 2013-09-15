From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.11+ merge window
Date: Sun, 15 Sep 2013 17:41:06 -0400
Message-ID: <CA+55aFzNShCSdmrXwabuhwvD=Q7tVL8io4cHGL7zKpxAM7Pixw@mail.gmail.com>
References: <1379276741.3315.23.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:59165 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab3IOVlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Sep 2013 17:41:07 -0400
In-Reply-To: <1379276741.3315.23.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, Sep 15, 2013 at 4:25 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> This patch set is a set of driver updates (megaraid_sas, fnic, lpfc,
> ufs, hpsa) we also have a couple of bug fixes (sd out of bounds and
> ibmvfc error handling) and the first round of esas2r checker fixes and
> finally the much anticipated big endian additions for megaraid_sas.

Just so you know - the next time I get these "new driver stuff" the
last day of the merge window, it will wait until the next release.
This happens way too often with you. You send one batch of stuff, and
then you delay the rest.

I'm going to pull this, but you're on notice.

                      Linus
