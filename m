From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] First round of SCSI updates for the 3.4+ merge window
Date: Tue, 22 May 2012 16:49:36 +0100
Message-ID: <1337701776.2932.15.camel@dabdike.int.hansenpartnership.com>
References: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
	 <CA+55aFz__YrXffza1bEzwrPu+-ETswUcg3F31Gjrj3OPbRyTZw@mail.gmail.com>
	 <1337671311.16400.12.camel@dabdike.int.hansenpartnership.com>
	 <CA+55aFzHVEph_MvPjb=QiK4bg8qBDmdpzkXS4C1RCFyBDj6ecg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48739 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078Ab2EVPtk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 11:49:40 -0400
In-Reply-To: <CA+55aFzHVEph_MvPjb=QiK4bg8qBDmdpzkXS4C1RCFyBDj6ecg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2012-05-22 at 08:44 -0700, Linus Torvalds wrote:
> On Tue, May 22, 2012 at 12:21 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > You probably need to do a gpg --refresh
> >
> > I use the subkeys method for signing, so I have my master key (which
> > expires in 2016) in one of Greg's GPG devices, but I have signing and an
> > encryption subkeys which are short lived (currently expire in Oct 2012).
> > If you do a gpg --list-keys 'James Bottomley' you'll see this:
> 
> Ayup, that fixed it. Really confusing how it doesn't even show the
> signing key expiry date if you just look at the key ID..

If you find *that* the only confusing thing about gpg, we'll award you
the gold star grand master of expertise in it.  When my subkeys expired,
it took me a day to figure out from the error message I got trying to
sign something what the problem actually was.

James


