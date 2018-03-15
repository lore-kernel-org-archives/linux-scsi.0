From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.16-rc5
Date: Wed, 14 Mar 2018 22:32:06 -0400
Message-ID: <yq1605yax21.fsf@oracle.com>
References: <1521070116.4508.94.camel@HansenPartnership.com>
        <CA+55aFzRss7BfRbLW8fsO5mRhj5obX9sg2ebkNSp5G68VmpWvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzRss7BfRbLW8fsO5mRhj5obX9sg2ebkNSp5G68VmpWvg@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 14 Mar 2018 17:09:14 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Linus,

> I've pulled it, but I don't see why (and how) this kind of garbage got
> reviewed and acked by multiple people.

My bad. I actually did notice the superfluous ifs and meant to nuke them
when I committed the patch.

However, I had a freak accident with my fixes branch that day that
compelled me to reset to my latest public hash and redo several
commits. I completely forgot that I had intended to tweak this patch
when I finally got around to applying it. I should have looked closer,
but it was already in my "done" pile.

Botched it. Sorry about that!

-- 
Martin K. Petersen	Oracle Linux Engineering
