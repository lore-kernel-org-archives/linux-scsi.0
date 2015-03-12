From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 17/22] esp_scsi: %pF is only for function pointers
Date: Thu, 12 Mar 2015 07:23:01 -0400
Message-ID: <55017715.60305@suse.de>
References: <1426130037-17956-1-git-send-email-scottwood@freescale.com> <1426130037-17956-17-git-send-email-scottwood@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426130037-17956-17-git-send-email-scottwood@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Wood <scottwood@freescale.com>, trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/11/2015 11:13 PM, Scott Wood wrote:
> Use %pS for actual addresses, otherwise you'll get bad output
> on arches like ppc64 where %pF expects a function descriptor.
>=20
> Signed-off-by: Scott Wood <scottwood@freescale.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: Hannes Reinecke <hare@suse.de>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
