From: Hannes Reinecke <hare@suse.de>
Subject: Re: Is there any plan to support 64bit lun in mainline?
Date: Mon, 14 Oct 2013 12:32:22 +0200
Message-ID: <525BC836.2030306@suse.de>
References: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab3JNKcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Oct 2013 06:32:25 -0400
In-Reply-To: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wangshen (C)" <peter.w@huawei.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Jinbo (Justin)" <jinbo@huawei.com>

On 10/12/2013 08:35 AM, Wangshen (C) wrote:
> Hello everyone,
>=20
> My name is Wang Shen.
> I am developing some scsi devices in Linux needs 64bit lun.
> Now I am in trouble in scsi driver programming.
>=20
> According to SAM-5, a LUN structure is 8 bytes long, but it is only 4=
 bytes long in kernel.
> In another word Linux kernel only supports single level LUN, except c=
onglomerate LUN and Hierarchical LUN.
> In my project, we need support all of the LUN structures.
>=20
> I find an archive mail on Tue, 19 Feb 2013 which discussed "scsi: 64-=
bit LUN support", but it just a patchset.
>=20
> Is there any plan to merge this patchset to mainline?
> If there is a plan, Which version will support 64bit lun?

Yes, there is a plan. Sort of.

I have a patchset (basically an update from the original patches)
sitting here in my private repository.

However, there are two other patchsets pending (EH Deadline and
asynchronous command aborts), both of which have been tested
thoroughly _and_ have acked-by from various other parties.
None of these patchset had received any feedback from James
Bottomley, let alone any indication if or when they'll be merged.

So I stopped sending further patchsets, sensing some communication
breakdown on the line.

I try to excite some response from James B. next week in Edinburgh.
At the very least there'll be other persons with whom I'll be able
to discuss further steps.

And yes, this is slightly irritating.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
