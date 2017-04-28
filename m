From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] target: fixup error message in
 target_tg_pt_gp_tg_pt_gp_id_store()
Date: Fri, 28 Apr 2017 17:21:46 +0000
Message-ID: <1493400105.2767.7.camel@sandisk.com>
References: <1493366644-8534-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17082 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755283AbdD1RVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2017 13:21:49 -0400
In-Reply-To: <1493366644-8534-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <1D294596C5EB6B43927704017C973AC3@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "nab@daterainc.com" <nab@daterainc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

On Fri, 2017-04-28 at 10:04 +0200, Hannes Reinecke wrote:
> When setting up an ALUA target port group with an invalid ID the
> error message
>=20
> kstrtoul() returned -22 for tg_pt_gp_id
>=20
> is displayed, which is not really helpful.
> Convert it to something sane.
> And while we're at it, join the messages onto a single line.

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>=
