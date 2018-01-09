From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] storvsc: do not assume SG list is continuous when doing
 bounce buffers (for 4.1 stable only)
Date: Tue, 9 Jan 2018 23:04:55 +0000
Message-ID: <MWHPR21MB0846048B1EE162042C46BD4ECE100@MWHPR21MB0846.namprd21.prod.outlook.com>
References: <1503379905-18908-1-git-send-email-longli@exchange.microsoft.com>
        <20170822062841.GA1061@infradead.org>
        <MWHPR21MB0190D1C8C3FAF25AE283ABCFCE840@MWHPR21MB0190.namprd21.prod.outlook.com>
        <20170823064319.GA19373@infradead.org> <yq1ziaq9un4.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ziaq9un4.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Christoph,
>=20
> > Ok.  If the stable maintainers are ok with your small fix I'm not
> > going to complain too loudly.  But I'm always worried about stable
> > trees divering too much from mainline.
>=20
> The seemingly innocuous transition from SG_GAPS to virt boundary has
> caused several data corruption regressions in the distro kernels. So has =
the
> corresponding conversion of storvsc.
>=20
> As a result, getting the current upstream code into 4.1 would mean
> backporting and testing a significant amount of both block layer and driv=
er
> code. I don't think it's worth the risk. This patch is simple and the pat=
h of least
> resistance.
>=20
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Sorry to bring up this patch again. It seems it hasn't made it to stable br=
anches.

Please take a look.

>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
