From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 24 Aug 2018 12:30:29 -0400
Message-ID: <yq15zzz917e.fsf@oracle.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
        <yq1in4gq5jf.fsf@oracle.com> <yq1lg8zb2lp.fsf@oracle.com>
        <20180822062016.GA10356@infradead.org>
        <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
        (Jeffrey Lien's message of "Fri, 24 Aug 2018 15:32:52 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Jeffrey Lien <Jeff.Lien@wdc.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Jeffrey,

> So it seems the CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y provides the best
> performance.

Thanks for confirming!

> Are there any negative side effect to this config option?

Other than kernel image size, not really.

-- 
Martin K. Petersen	Oracle Linux Engineering
