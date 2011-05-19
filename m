From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Submit commit 3dea642afd for 2.6.38.stable?
Date: Wed, 18 May 2011 23:51:28 -0700 (PDT)
Message-ID: <108481.42293.qm@web31801.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.66]:22778 "HELO
	nm7-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754845Ab1ESGvd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2011 02:51:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Bottomley <James.Bottomley@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>, stable@kernel.org

--- On Wed, 5/18/11, Luben Tuikov <ltuikov@yahoo.com> wrote:
> From: Luben Tuikov <ltuikov@yahoo.com>
> Subject: Re: Submit commit 3dea642afd for 2.6.38.stable?
> To: "Alan Stern" <stern@rowland.harvard.edu>, "James Bottomley" <Jame=
s.Bottomley@HansenPartnership.com>
> Cc: "James Bottomley" <James.Bottomley@suse.de>, "SCSI development li=
st" <linux-scsi@vger.kernel.org>, stable@kernel.org
> Date: Wednesday, May 18, 2011, 11:07 PM
> --- On Wed, 5/18/11, James Bottomley
> <James.Bottomley@HansenPartnership.com>
> wrote:
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Subject: Re: Submit commit 3dea642afd for
> 2.6.38.stable?
> > To: "Alan Stern" <stern@rowland.harvard.edu>
> > Cc: "James Bottomley" <James.Bottomley@suse.de>,
> "Luben Tuikov" <ltuikov@yahoo.com>,
> "SCSI development list" <linux-scsi@vger.kernel.org>,
> stable@kernel.org
> > Date: Wednesday, May 18, 2011, 9:02 PM
> > On Mon, 2011-05-16 at 16:45 -0400,
> > Alan Stern wrote:
> > > James:
> > >=20
> > > Your commit
> 3dea642afd9187728d119fce5c82a7ed9faa9b6a
> > ([SCSI] Revert
> > > "[SCSI] Retrieve the Caching mode page") hasn't
> been
> > submitted for the
> > > 2.6.38 stable tree.=A0 More people are now
> getting
> > hit with the
> > > underlying problem; see
> > >=20
> > > =A0=A0=A0 https://bugzilla.kernel.org/show_bug.cgi?id=3D35042
> >=20
> > OK, yes, the reversion needs sending to stable ... can
> you
> > do that?
> >=20
> > > Do you want to queue your commit to the stable
> tree,
> > or do you prefer
> > > to wait until the proper repair patch:
> > >=20
> > > =A0=A0=A0 http://marc.info/?l=3Dlinux-scsi&m=3D130089710431684&w=3D=
2
> > >=20
> > > has been merged so it can go into the stable
> tree
> > instead?
> > >=20
> > > Alan Stern
> > >=20
> > > P.S.: As of now, the scsi-next tree doesn't show
> any
> > signs of
> > > reinstating Luben's original commit together with
> my
> > repair patch.=A0=20
> > > Does this mean you intend to forget about the
> original
> > "Retrieve the
> > > Caching mode page" change, or do you intend to
> merge
> > them for 2.6.41?)
> >=20
> > Actually, no, I was waiting for you to send the
> combined
> > patch (with
> > both signoffs) rather than having me reconstruct it.
>=20
> Bottomley,
>=20
> 1. How is this any different than applying Alan's patch on
> top of mine?
> The net effect is the same. For example, applying my patch
> (reverting your
> revert of my patch) and then applying Alan's would result
> in what you
> want, OTHER THAN what you're suggesting above would be a
> single coming
> FROM Alan, as opposed to one from ME and another from
> Alan.
>=20
> Please explain.
>=20
> 2. Would you accept a resubmit of my patch as [1/2] from me
> and [2/2] from
> Alan. In fact someone can do this in their tree and you can
> pull from
> them. That is, why do you INSIST on this being a "singe
> comming from
> [Alan]". Why can it not be two commits, in which you don't
> care if you
> pull from someone else's tree (Alan's or Greg's or
> whomever).
>=20
> 3. Or, would you accept a patch from me, that _includes_
> Alan's smaller
> commit that adds a few checks to my bigger commit which
> actually introduces
> functionality.
>=20
> Please explain.

Basically, what would've been a really simple procedure, followed by
every other subsystem maintainer (other than yourself apparently),
namely applying Alan's patch (http://marc.info/?l=3Dlinux-scsi&m=3D1300=
89710431684&w=3D2)
into the same tree which which already has my patch (http://marc.info/?=
l=3Dlinux-usb&m=3D129044500027668&w=3D2)
has now turned into a broken tree, and your wanting a single commit of
both, just because you reverted my patch in your own tree.

Very unusual work flow.

    Luben


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
