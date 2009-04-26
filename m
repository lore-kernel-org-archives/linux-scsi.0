From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: qla2xxx async scan in kernel 2.6.16
Date: Sun, 26 Apr 2009 17:27:35 +0000
Message-ID: <1240766855.4627.2.camel@mulgrave.int.hansenpartnership.com>
References: <d364733c0904260904t1ba66e7ey1caef491d6428866@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51152 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbZDZR1h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Apr 2009 13:27:37 -0400
In-Reply-To: <d364733c0904260904t1ba66e7ey1caef491d6428866@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?=E8=B0=A2=E7=BA=B2?= <xiegang112@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2009-04-27 at 00:04 +0800, =E8=B0=A2=E7=BA=B2 wrote:
> In kernel 2.6.16, I find that there is no scsi_scan_host in
> qla2xxx_probe_one. So how does the qla driver scan the scsi device?

scsi_scan_host() is only really for non hotplug busses that need a fixe=
d
id scan.

Hotplug buses use scsi_scan_target() instead when the device appears on
the bus.  Most do this (like fc) from the target port appearance via th=
e
allied transport class.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
