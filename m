From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: fix sysfs writes to "provisioning_mode" and
 "zeroing_mode"
Date: Mon, 15 May 2017 20:14:50 +0000
Message-ID: <1494879289.2567.3.camel@sandisk.com>
References: <1494875606-6298-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1973 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934544AbdEOUOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 16:14:53 -0400
In-Reply-To: <1494875606-6298-1-git-send-email-emilne@redhat.com>
Content-Language: en-US
Content-ID: <027CF85682E9D24B8A0AD94629A041CA@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "emilne@redhat.com" <emilne@redhat.com>

On Mon, 2017-05-15 at 15:13 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>=20
> Change to use strlen() of the desired string for the length
> parameter to strncmp().  Otherwise one cannot simply use a
> command like 'echo "writesame_16" > .../provisioning_mode'.
> This patch makes sysfs writes consistent with other usage.

Hello Ewan,

Sorry but I don't like the approach of this patch. Have you considered
to strip the whitespace from 'buf' with e.g. strim() such that strcmp()
can be used instead of strncmp(buf, ..., strlen(...))?

Thanks,

Bart.=
