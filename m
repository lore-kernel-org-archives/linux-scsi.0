From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/4] block: Integrity profile init function to trigger module loads
Date: Sun, 26 Aug 2018 09:48:55 -0400
Message-ID: <yq1d0u56xx4.fsf@oracle.com>
References: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
        <20180826024006.13800-1-martin.petersen@oracle.com>
        <20180826024006.13800-4-martin.petersen@oracle.com>
        <CAKv+Gu92yj5Cuz36bRS7wz3Lg2srp8OFJC6QVO0UWYSjm8eEeg@mail.gmail.com>
        <yq1h8jh6yrk.fsf@oracle.com>
        <CAKv+Gu88A8OmVGV3-9YGkgNKOtCRmN70Ys2WL+F7au=NB4vydQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu88A8OmVGV3-9YGkgNKOtCRmN70Ys2WL+F7au=NB4vydQ@mail.gmail.com>
        (Ard Biesheuvel's message of "Sun, 26 Aug 2018 15:44:31 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jeffrey Lien <Jeff.Lien@wdc.com>, David Darrington <david.darrington@wdc.com>, Christoph Hellwig <hch@infradead.org>, Jeff Furlong <jeff.furlong@wdc.com>, linux-block@vger.kernel.org, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org


Ard,

> That is odd. On my Ubuntu system, both crct10dif_pclmul and
> crc32_pclmul get loaded automatically.

Just checked my Fedora box and they are loaded there too. Peculiar. I'll
keep digging...

(crc32c-intel is brought in by dracut on RHEL/OL/Fedora, fwiw)

-- 
Martin K. Petersen	Oracle Linux Engineering
