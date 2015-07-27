From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/8] qla2xxx: disable scsi_transport_fc registration
 in target mode
Date: Mon, 27 Jul 2015 10:17:00 +0200
Message-ID: <55B5E8FC.1050502@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-7-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436904049-27707-7-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/14/2015 10:00 PM, Himanshu Madhani wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>=20
> There are multiple reasons for disabling this:
>=20
> 1. It provides no functional benefit. We pretty much only get a few m=
ore
> sysfs entries for each port, but all that information is already
> available from /sys/kernel/debug/target/qla-session-X
>=20
> 2. It already only works in private-loop mode. By disabling we'll be
> getting more uniform behavior with fabric mode.
>=20
> 3. It creates complications for the new PLOGI handling mechanism:
> scsi_transport_fc port deletion timer could race with new session
> from initiator and cause logout after successful login.
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
