From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: declare MODULE_FIRMWARE in libsas
Date: Tue, 04 Jan 2011 22:36:32 -0600
Message-ID: <1294202192.7879.30.camel@mulgrave.site>
References: <4D22CF9F.1070005@oracle.com>
	 <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org>
	 <4D23E315.9060900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab1AEEgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2011 23:36:40 -0500
In-Reply-To: <4D23E315.9060900@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 11:18 +0800, DuanZhenzhong wrote:
> Jeff Garzik =E5=86=99=E9=81=93:
> > On 01/04/2011 09:08 AM, James Bottomley wrote:
> >> On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
> >>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
> >>>
> >>> ---
> >>
> >> Description?  Since libsas has no firmware, surely some explanatio=
n is
> >> required.
> >
> > Indeed.  Looks bogus at first glance?
> >
> >
> I was finding all requested but not exported firmware in scsi driver =
for=20
> generating dump initrd use.
> In sas_scsi_host.c, request_firmware is called with "sas_addr", sas_a=
ddr=20
> neither builtin nor exported. Don't sas_addr a firmware? Please corre=
ct=20
> me. thanks

No, it's not requesting any firmware ... it's a slight misuse of the
firmware mechanism that allows a libsas based driver to be given a SAS
address if it doesn't have an internal nsvram to store one.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
