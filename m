From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.3.0
Date: Wed, 6 Oct 2004 11:50:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041006095009.GD1542@marowsky-bree.de>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1097054573.4163b96d1262c@imp5-q.free.fr>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2004-10-06T11:22:53, christophe.varoqui@free.fr wrote:

> here goes multipath-tools-0.3.0
>=20
> Faster release cycle.
> Big things for some people out there.
> Upgrade will need you to manualy remove your /etc/udev/rules.d/multip=
ath.rules
> and kill your devmap_name rule in udev.rules (we use a separate rules=
=2Ed file
> now)

Hi Christophe, do you still plan further configuration file changes in
the immediate future or will the format of the configuration settle dow=
n
now?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
