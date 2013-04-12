From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 18/26] megaraid: Don't use create_proc_read_entry() [RFC]
Date: Fri, 12 Apr 2013 10:56:11 +0200
Message-ID: <5167CC2B.7070005@suse.de>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk> <20130411133001.32763.78829.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130411133001.32763.78829.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neela Syam Kolli <megaraidlinux@lsi.com>, viro@ZenIV.linux.org.uk, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/11/2013 03:30 PM, David Howells wrote:
> Don't use create_proc_read_entry() as that is deprecated, but rather =
use
> proc_create_data() and seq_file instead.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> cc: James E.J. Bottomley <JBottomley@parallels.com>
> cc: linux-scsi@vger.kernel.org

Hmm?
What is the general stance on /proc entries for devices?
I was under the impression that it was marked as deprecated.

Is it not? Has it been resurrected?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
