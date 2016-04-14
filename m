From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/42] v5: separate operations from flags in the
 bio/request structs
Date: Thu, 14 Apr 2016 08:09:30 +0200
Message-ID: <570F341A.2040108@suse.de>
References: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 04/13/2016 09:35 PM, mchristi@redhat.com wrote:
> The following patches begin to cleanup the request->cmd_flags and
> bio->bi_rw mess. We currently use cmd_flags to specify the operation,
> attributes and state of the request. For bi_rw we use it for similar
> info and also the priority but then also have another bi_flags field
> for state. At some point, we abused them so much we just made cmd_fla=
gs
> 64 bits, so we could add more.
>=20
> The following patches seperate the operation (read, write discard,
> flush, etc) from cmd_flags/bi_rw.
>=20
> This patchset was made against linux-next from today April 13
> (git tag next-20160413).
>=20
> I put a git tree here:
> https://github.com/mikechristie/linux-kernel.git
> The patches are in the op branch.
>=20
A round of applause for you.

=46or the entire series:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
