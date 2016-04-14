From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] target: use new "dbroot" target attribute
Date: Thu, 14 Apr 2016 08:10:54 +0200
Message-ID: <570F346E.7050902@suse.de>
References: <cover.1460577841.git.lduncan@suse.com>
 <4deb4b5219c4b30e18569380b82359f242f2a25b.1460577841.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4deb4b5219c4b30e18569380b82359f242f2a25b.1460577841.git.lduncan@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, agrover@redhat.com, jxm@netiant.com
List-Id: linux-scsi@vger.kernel.org

On 04/13/2016 10:25 PM, Lee Duncan wrote:
> This commit updates the target core ALUA and PR
> modules to use the new "dbroot" attribute instead
> of assuming the target database is in "/var/target".
>=20
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/target/target_core_alua.c | 6 +++---
>  drivers/target/target_core_pr.c   | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
