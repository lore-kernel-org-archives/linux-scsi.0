From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 2/2] hpsa: export resettable_on_kexec host attribute
Date: Wed, 9 Mar 2011 08:36:09 -0600
Message-ID: <20110309143609.GG12760@beardog.cce.hp.com>
References: <20110308230749.22291.56200.stgit@beardog.cce.hp.com> <20110308231003.22291.20417.stgit@beardog.cce.hp.com> <20110309063339.GB16951@cr0.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:18277 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab1CIOgL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2011 09:36:11 -0500
Content-Disposition: inline
In-Reply-To: <20110309063339.GB16951@cr0.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

On Wed, Mar 09, 2011 at 02:33:39PM +0800, Am=E9rico Wang wrote:
> On Tue, Mar 08, 2011 at 05:10:03PM -0600, Stephen M. Cameron wrote:
> >From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >
> >This attribute, requested by Redhat, allows kexec-tools to know
> >whether the controller can honor the reset_devices kernel parameter
> >and actually reset the controller.  For kdump to work properly it
> >is necessary that the reset_devices parameter be honored.  This
> >attribute enables kexec-tools to warn the user if they attempt to
> >designate a non-resettable controller as the dump device.
> >
> >Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>=20
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
>=20
> Maybe we should docment this sysfs attribute somewhere?

Yes, thanks. =20

Perhaps in Documentation/ABI/testing/sysfs-bus-scsi-devices-hpsa
(which doesn't exist) and/or in Documentation/scsi/hpsa.txt (which does=
 exist, and
is where other hpsa specific sysfs attributes are documented.)  Probabl=
y so
as not to duplicate things, the latter.  Or maybe what documentation of
sysfs things that is currently in hpsa.txt should be moved to Documenta=
tion/ABI/...
and a reference to it put in hpsa.txt?

-- steve
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
