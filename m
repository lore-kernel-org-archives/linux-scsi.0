From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] First round of SCSI updates for the 3.4+ merge window
Date: Tue, 22 May 2012 08:21:51 +0100
Message-ID: <1337671311.16400.12.camel@dabdike.int.hansenpartnership.com>
References: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
	 <CA+55aFz__YrXffza1bEzwrPu+-ETswUcg3F31Gjrj3OPbRyTZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFz__YrXffza1bEzwrPu+-ETswUcg3F31Gjrj3OPbRyTZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-05-21 at 17:52 -0700, Linus Torvalds wrote:
> On Mon, May 21, 2012 at 4:30 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > The patch contains the usual assortment of driver updates (be2iscsi,
> > bfa, bnx2i, fcoe, hpsa, isci, lpfc, megaraid, mpt2sas, pm8001, sg) plus
> > an assortment of other changes and fixes.  Also new is the fact that the
> > isci update is delivered as a git merge (with signed tag).
> 
> Interesting. For some reason the 'gpg --verify' phase says that your
> key has expired. Yet when I look at the key itself, it says it is
> valid until 2016. I don't quite know why gpg thinks the thing is
> expired when verifying the message.

You probably need to do a gpg --refresh

I use the subkeys method for signing, so I have my master key (which
expires in 2016) in one of Greg's GPG devices, but I have signing and an
encryption subkeys which are short lived (currently expire in Oct 2012).
If you do a gpg --list-keys 'James Bottomley' you'll see this:

pub   2048R/214854D6 2011-09-23 [expires: 2016-09-27]
uid                  James Bottomley
<James.Bottomley@HansenPartnership.com>
uid                  James Bottomley <JBottomley@Parallels.com>
uid                  James Bottomley <jejb@kernel.org>
uid                  [jpeg image of size 5254]
sub   2048R/0D77E313 2011-09-23 [expires: 2012-10-25]
sub   2048R/2C5CBD0C 2011-10-27 [expires: 2012-10-25]

The 2048R/2C5CBD0C is my signature one.  I have to update the expiry of
them every six months, so you probably haven't done a refresh since I
did the update.

I do it this way so that I don't have to carry my master key with me
when travelling (or if I do, I don't have to use it except for signing
other keys, since the GPG devices are a bit cumbersome), so if something
goes wrong, I can revoke my subkey and just generate a new one (without
having to get everyone's signature again).

> But everything else looks fine. Somebody with more gpg-fu than me
> might be able to clarify what is going on..

Hope the above helps (would rather not have had to become a gpg advanced
user, but there you go ...)

James
