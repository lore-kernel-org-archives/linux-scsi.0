From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] First round of SCSI updates for the 3.4+ merge window
Date: Tue, 22 May 2012 08:44:30 -0700
Message-ID: <CA+55aFzHVEph_MvPjb=QiK4bg8qBDmdpzkXS4C1RCFyBDj6ecg@mail.gmail.com>
References: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
 <CA+55aFz__YrXffza1bEzwrPu+-ETswUcg3F31Gjrj3OPbRyTZw@mail.gmail.com> <1337671311.16400.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337671311.16400.12.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 22, 2012 at 12:21 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> You probably need to do a gpg --refresh
>
> I use the subkeys method for signing, so I have my master key (which
> expires in 2016) in one of Greg's GPG devices, but I have signing and an
> encryption subkeys which are short lived (currently expire in Oct 2012).
> If you do a gpg --list-keys 'James Bottomley' you'll see this:

Ayup, that fixed it. Really confusing how it doesn't even show the
signing key expiry date if you just look at the key ID..

                 Linus
