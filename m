From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] target: Subsume se_port + t10_alua_tg_pt_gp_member
 into se_lun
Date: Fri, 22 May 2015 09:58:30 +0200
Message-ID: <555EE1A6.6090001@suse.de>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com> <1432278417-29994-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432278417-29994-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 05/22/2015 09:06 AM, Nicholas A. Bellinger wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> This patch eliminates all se_port + t10_alua_tg_pt_gp_member usage,
> and converts current users to direct se_lun pointer dereference.
>=20
> This includes the removal of core_export_port(), core_release_port()
> core_dev_export() and core_dev_unexport().  Along with conversion
> of special case se_lun pointer dereference within PR ALL_TG_PT=3D1
> and ALUA access state transition UNIT_ATTENTION handling.
>=20
> Also, update core_enable_device_list_for_node() to reference the
> new per se_lun->lun_deve_list when creating a new entry, or
> replacing an existing one via RCU.
>=20
> (Fix l_tg_pt_gp reference in set_target_port_groups - nab)
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
