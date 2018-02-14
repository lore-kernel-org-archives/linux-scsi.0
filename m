From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.16-rc1
Date: Wed, 14 Feb 2018 15:30:51 -0500
Message-ID: <yq1k1vfmhz8.fsf@oracle.com>
References: <1518639578.3223.44.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518639578.3223.44.camel@HansenPartnership.com> (James
        Bottomley's message of "Wed, 14 Feb 2018 12:19:38 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


James,

> These are mostly fixes for problems with merge window code. =C2=A0In
> addition we have one doc update (alua) and two dead code removals
> (aiclib and octogon) a spurious assignment removal (csiostor) and a
> performance improvement for storvsc involving better interrupt
> spreading and increasing the command per lun handling.

Looks like your tree is out of sync with mine. I dropped one of the
storvsc commits that broke build on non-SMP due to a missing macro.

--=20
Martin K. Petersen	Oracle Linux Engineering
