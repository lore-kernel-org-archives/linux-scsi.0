From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Tue, 10 Sep 2002 15:04:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020910130427.GP2992@marowsky-bree.de>
References: <patmans@us.ibm.com> <200209091734.g89HY5p11796@localhost.localdomain> <20020909170847.A24352@eng2.beaverton.ibm.com> <10209100055.ZM65139@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10209100055.ZM65139@classic.engr.sgi.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2002-09-10T00:55:58,
   Jeremy Higdon <jeremy@classic.engr.sgi.com> said:

> Is there any plan to do something for hardware RAIDs in which two dif=
ferent
> RAID controllers can get to the same logical unit, but you pay a perf=
ormance
> penalty when you access the lun via both controllers?=20

This is implemented in the md multipath patch in 2.4; it distinguishes =
between
"active" and "spare" paths.

The LVM1 patch also does this by having priorities for each path and on=
ly
going to the next priority group if all paths in the current one have f=
ailed,
which IMHO is slightly over the top but there is always someone who mig=
ht need
it ;-)

This functionality is a generic requirement IMHO.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Immortality is an adequate definition of high availability for me.
	--- Gregory F. Pfister
