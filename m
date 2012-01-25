From: "Christopher R. Hertel" <crh@samba.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] linux servers as a storage server - what's
 missing?
Date: Wed, 25 Jan 2012 14:25:39 -0600
Message-ID: <4F206543.60309@samba.org>
References: <4EF2026F.2090506@redhat.com> <20120103142609.2b4d06cb@tlielax.poochiereds.net> <20120124213609.GA12426@fieldses.org> <4F1F3B00.8060603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:33661
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430Ab2AYUbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 15:31:24 -0500
In-Reply-To: <4F1F3B00.8060603@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Allison <jra@samba.org>, Simo Sorce <simo@redhat.com>

I have actually been mulling this over a good deal in my mind, but I keep
approaching it from different perspectives.

Here are some random questions that pop up in my mind...

Can we put FibreChannel HBAs in *target* mode into a Linux-based PC and
export LUNs via FibreChannel?
  - Do we support multipath in this configuration?
  - Zoning?  Muli-access LUNs for Clustering?

Where are we on FCoE support?

Where to we stand on ATAoE?
  - Coraid, the creaters of ATAoE, were recently listed 3rd on a
    "Most Promising Storage Start-Ups in 2012" list[1].
  - ATAoE support has been standard in Linux for years.
  - The target software is very low-level.  It needs an overhaul
    and a powerful configuration API.

What about other block-level protocols?  My familiarity with these varies.

Chris -)-----


[1]http://www.storagenewsletter.com/news/startups/most-promising-storage-start-ups


Ric Wheeler wrote:
> On 01/24/2012 04:36 PM, J. Bruce Fields wrote:
>> On Tue, Jan 03, 2012 at 02:26:09PM -0500, Jeff Layton wrote:
>>> On Wed, 21 Dec 2011 10:59:43 -0500
>>> Ric Wheeler<rwheeler@redhat.com>  wrote:
>>>
>>>> One common thing that I see a lot of these days is an increasing
>>>> number of
>>>> platforms that are built on our stack as storage servers. Ranging
>>>> from the
>>>> common linux based storage/NAS devices up to various distributed
>>>> systems.
>>>> Almost all of them use our common stack - software RAID, LVM,
>>>> XFS/ext4 and samba.
>>>>
>>>> At last year's SNIA developers conference, it was clear that
>>>> Microsoft is
>>>> putting a lot of effort into enhancing windows 8 server as a storage
>>>> server with
>>>> both support for a pNFS server and of course SMB. I think that linux
>>>> (+samba) is
>>>> ahead of the windows based storage appliances today, but they are
>>>> putting
>>>> together a very aggressive list of features.
>>>>
>>>> I think that it would be useful and interesting to take a slot at
>>>> this year's
>>>> LSF to see how we are doing in this space. How large do we need to
>>>> scale for an
>>>> appliance?  What kind of work is needed (support for the copy
>>>> offload system
>>>> call? better support for out of band notifications like those used
>>>> in "thinly
>>>> provisioned" SCSI devices? management API's? Ease of use CLI work?
>>>> SMB2.2 support?).
>>>>
>>>> The goal would be to see what technical gaps we have that need more
>>>> active
>>>> development in, not just a wish list :)
>>>>
>>>> Ric
>>> Unfortunately, w/o a wishlist of sorts, it's hard to know what needs
>>> more active development ;).
>>>
>>> While HCH will probably disagree, being able to support more
>>> NFSv4/Windows API features at the VFS layer would make it a lot easier
>>> to do a more unified serving appliance. Right now, both knfsd and samba
>>> track too much info internally, and that makes it very difficult to
>>> serve the same data via multiple protocols.
>> By the way, we could really use a
>> Windows/Samba expert if we're going to discuss that.
>>
>> I don't think their list(s) got the announcement?
>>
>> --b.
> 
> Adding in three windows/samba people that I know of :)
> 
> Ric
> 
>>> Off the top of my head, my "wishlist" for better NFSv4 serving would be:
>>>
>>> - RichACLs
>>> - Share/Deny mode support on open
>>> - mandatory locking that doesn't rely on weirdo file modes
>>>
>>> It's always going to be hard for us to compete with dedicated
>>> appliances. Where Linux can shine though is in allowing for more
>>> innovative combinations.
>>>
>>> Being able to do active/active NFS serving from clustered filesystems,
>>> for instance is something that we can eventually attain but that would
>>> be harder to do in an appliance. This sort of discussion might also
>>> dovetail with Benny's proposal about pNFS serving.
>>>
>>> -- 
>>> Jeff Layton<jlayton@redhat.com>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-fsdevel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
