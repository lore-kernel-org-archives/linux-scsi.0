From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] target: Drop unnecessary core_tpg_register TFO parameter
Date: Fri, 22 May 2015 10:00:13 +0200
Message-ID: <555EE20D.1070307@suse.de>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com> <1432278417-29994-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432278417-29994-5-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/2015 09:06 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> This patch drops unnecessary target_core_fabric_ops parameter usage
> for core_tpg_register() during fabric driver TFO->fabric_make_tpg()
> se_portal_group creation callback execution.
>=20
> Instead, use the existing se_wwn->wwn_tf->tf_ops pointer to ensure
> fabric driver is really using the same TFO provided at module_init
> time.
>=20
> Also go ahead and drop the forward TFO declarations tree-wide, and
> handling the special case for iscsi-target discovery TPG.
>=20
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
