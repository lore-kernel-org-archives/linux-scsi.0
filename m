From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 09/10] aacraid: Fix character device re initialization
Date: Wed, 02 Dec 2015 10:18:27 +0100
Message-ID: <1449047907.3103.39.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-11-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbbLBJSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 04:18:30 -0500
In-Reply-To: <1448973589-9216-11-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

Hi=C2=A0Raghava,
On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> During EEH PCI hotplug activity kernel unloads and loads the driver,
> causing character device to be unregistered(aac_remove_one).When the
> driver is loaded back using aac_probe_one the character device needs
> to be registered again for the AIF management tools to work.
>=20
> Fixed by adding code to register character device in aac_probe_one if
> it is unregistered in aac_remove_one.
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>

This one is duplicate, isn't it?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
