From: "Christopher R. Hertel" <crh@samba.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] linux servers as a storage server - what's
 missing?
Date: Wed, 25 Jan 2012 16:09:56 -0600
Message-ID: <4F207DB4.50804@samba.org>
References: <4EF2026F.2090506@redhat.com> <20120103142609.2b4d06cb@tlielax.poochiereds.net> <20120124213609.GA12426@fieldses.org> <4F1F3B00.8060603@redhat.com> <4F206543.60309@samba.org> <CAL1RGDWxbYHQdFOxAfEWSxxjQKjQgsPgVAGYrZL4NrsB2apKzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDWxbYHQdFOxAfEWSxxjQKjQgsPgVAGYrZL4NrsB2apKzw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Allison <jra@samba.org>, Simo Sorce <simo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Roland Dreier wrote:
> On Wed, Jan 25, 2012 at 12:25 PM, Christopher R. Hertel <crh@samba.org> wrote:
>> Can we put FibreChannel HBAs in *target* mode into a Linux-based PC and
>> export LUNs via FibreChannel?
>>  - Do we support multipath in this configuration?
>>  - Zoning?  Muli-access LUNs for Clustering?
> 
> Yes to everything, although the low-level FC driver patches are not
> quite upstream yet.

Cool!
Thanks for the update.

I assume that the management API for this is similar to or the same as the
FCoE API?  That would make it easier to produce a consistent look-and-feel
in whatever end-user management tools a third-party my create.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
