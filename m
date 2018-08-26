From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Sat, 25 Aug 2018 22:35:23 -0400
Message-ID: <yq1lg8t7t3o.fsf@oracle.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
        <yq1in4gq5jf.fsf@oracle.com> <yq1lg8zb2lp.fsf@oracle.com>
        <20180822062016.GA10356@infradead.org>
        <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
        <CAKv+Gu-RwCrdgW69NVpyRLwGPGPCZx+ksTBM7NZk7v0-dzczGg@mail.gmail.com>
        <yq1a7pb9196.fsf@oracle.com>
        <CAKv+Gu8Y7YmyB5rmxaj-SGB7q03in7ijv2cOifwYnhP5CNastw@mail.gmail.com>
        <yq1tvnj780o.fsf@oracle.com>
        <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au> (Herbert
        Xu's message of "Sat, 25 Aug 2018 14:12:05 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeffrey Lien <Jeff.Lien@wdc.com>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Herbert,

> I don't think this is safe unless you do some kind of locking
> which would slow down the data path.  The easiest fix would be
> to keep the old tfm around forever, or use RCU if RCU read locking
> is acceptable to your use-case.

You're right. There's a small race there.

Patch series coming...

-- 
Martin K. Petersen	Oracle Linux Engineering
