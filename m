From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Wed, 14 Jan 2015 12:26:48 +0100
Message-ID: <54B65278.1030406@suse.de>
References: <54B63F74.2040702@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54B63F74.2040702@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 01/14/2015 11:05 AM, Bart Van Assche wrote:
> The LIO and SCST SCSI target subsystems consist of the following comp=
onents:
> * A core that processes SCSI commands and that provides common
> functionality like persistent reservations, LUN masking and an interf=
ace
> that allows configuration from user space.
> * Device handlers that allow this core to access SCSI devices, block
> devices and files uniformly as SCSI devices.
> * Target drivers that implement a storage protocol (iSCSI, FC, SRP,
> iSER, FCoE, ...) and that realize the SCSI request and response
> communication between the target system and an initiator system.
>=20
> A significant amount of code is shared between several LIO target
> drivers and the SCST target drivers that implement the same storage
> protocol. Since there are two sets of these drivers this means that e=
ach
> set has to be maintained, extended and tested separately. This means =
a
> lot of redundant work. The main difference between these two sets of
> drivers is the interface between the target drivers and the SCSI targ=
et
> core.  Hence the proposal to discuss the unification of the API betwe=
en
> SCSI target core and SCSI target drivers. Implementing a single unifi=
ed
> API would have the following advantages:
> * A single set of target drivers works for both projects which means =
a
> reduction of the maintenance effort for those who maintain target
> drivers for target driver developers and target driver users.
> * This would increase the size of the user base for the unified targe=
t
> drivers.
> * This would reduce the workload for the storage target maintainers.
> * This would motivate the SCST target driver maintainers to contribut=
e
> to the upstream target drivers and to bring the upstream SRP and FCoE
> target drivers to the same feature and stability level as their SCST
> counterparts. In other words, the LIO users would also benefit from t=
his
> work.
> * This effort would also help SCST users by ensuring that all latest
> target driver features are also available to SCST users. Some time ag=
o
> (but no longer today) the LIO QLogic target driver was ahead of the S=
CST
> QLogic target driver. This motivated an SCST user to port the LIO QLo=
gic
> target driver to SCST. See also Greg Wettstein, New release of
> SCST/Qlogic target interface driver, linux-scsi, April 2014,
> http://marc.info/?l=3Dlinux-scsi&m=3D139649571807085).
>=20
> During the first phase of this initiative the focus will be on the
> QLogic FC, SRP and FCoE target drivers since a significant part of th=
e
> code of these drivers is shared between the two target frameworks.
>=20
> For those who are not following the SCST project: I'm maintaining the
> SCST SRP and FCoE target drivers.
>=20
> Nic, in case it was not yet clear, you would be more than welcome dur=
ing
> this session :-)
>=20
I'd like to have this discussion, too.

It would be really good if we can make that work; after all, Linux
should be about _choice_. So if both parties agree to have this
discussion I'm all for it.
I can even act as a moderator if required :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
