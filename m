From: Roland Dreier <roland@purestorage.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] linux servers as a storage server - what's missing?
Date: Wed, 25 Jan 2012 13:56:35 -0800
Message-ID: <CAL1RGDWxbYHQdFOxAfEWSxxjQKjQgsPgVAGYrZL4NrsB2apKzw@mail.gmail.com>
References: <4EF2026F.2090506@redhat.com> <20120103142609.2b4d06cb@tlielax.poochiereds.net>
 <20120124213609.GA12426@fieldses.org> <4F1F3B00.8060603@redhat.com> <4F206543.60309@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F206543.60309@samba.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Christopher R. Hertel" <crh@samba.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Allison <jra@samba.org>, Simo Sorce <simo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2012 at 12:25 PM, Christopher R. Hertel <crh@samba.org>=
 wrote:
> Can we put FibreChannel HBAs in *target* mode into a Linux-based PC a=
nd
> export LUNs via FibreChannel?
> =A0- Do we support multipath in this configuration?
> =A0- Zoning? =A0Muli-access LUNs for Clustering?

Yes to everything, although the low-level FC driver patches are not
quite upstream yet.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
