From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: Update to SCSI trees for Linux Next
Date: Thu, 26 Apr 2012 13:21:09 -0700
Message-ID: <CAA9_cmcWz3uWJTHs1Efe4NWpD9KQaxXzpWHVuG6G5uoyMwEA5g@mail.gmail.com>
References: <1335177821.4191.17.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1335177821.4191.17.camel@dabdike.lan>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 23, 2012 at 3:43 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Hi Stephen
>
> Just to let you know that SCSI is moving on to a single tree model fr=
om
> now on. =A0The new tree is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>
> And the branch for next is for-next.
>
> Could you drop both the scsi-misc-2.6 and scsi-rc-fixes-2.6 tree, ple=
ase
> because I'll send everything through this for-next branch.
>
> For the time being, could you keep the scsi-post-merge-2.6 tree? =A0I=
t's
> easier when resolving conflicts amongst other trees to use a separate
> git tree (although we haven't actually had to use this one for a whil=
e).

Speaking of resolving conflicts, are you looking to resolve conflicts
between scsi/fixes and development branches targeted at the next merge
window?  Or, would you rather ask the development branch to rebase on
top of latest Linus once scsi/fixes lands upstream?

My libsas development branch, if I base it on current Linus, will
conflict with the bits queued in scsi/fixes.

--
Dan
