From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Re:[PATCH 0/5] AIC7xxx port of latests AIC79xx patchs
Date: Fri, 28 Apr 2006 09:24:06 -0500
Message-ID: <1146234246.3527.27.camel@mulgrave.il.steeleye.com>
References: <IWURLU$9A7E79C7D8BCF1A9AE8A8B540822E5C2@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:7852 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030316AbWD1OYR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 10:24:17 -0400
In-Reply-To: <IWURLU$9A7E79C7D8BCF1A9AE8A8B540822E5C2@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel =?ISO-8859-1?Q?Fust=E9?= <emmanuel.fuste@laposte.net>
Cc: hare <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-03-28 at 21:32 +0200, Emmanuel Fust=C3=A9 wrote:
> > Hello,
> >=20
> > I port latest Hannes Reinecke patchs to aic7xxx.
> > Compile tested only, runtime report later.
> >=20
> Ok,
> As you could see all work fine.
> Now it will be time to triger the recovery part.
> Will now try the killer cmd: cdrwtools -d /dev/scd0 -q

Is there any update on this ... like have you actually tested with
actual hardware?

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
