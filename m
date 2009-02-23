From: Prakash Punnoor <prakash@punnoor.de>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Mon, 23 Feb 2009 19:21:22 +0100
Message-ID: <200902231921.22759.prakash@punnoor.de>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221617.21621.prakash@punnoor.de> <49A23FBA.2020004@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <49A23FBA.2020004@kernel.org>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robert Hancock <hancockrwd@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Montag 23 Februar 2009 07:18:34 Yinghai Lu wrote:
> please try, you may need Eric's patch too.
>
> [PATCH] pci: don't enable too much HT MSI mapping
>
> Impact: fix bug
>
> Prakesh reported that his c51-mcp51 system ondie sound card doesn't work
> MSI but if he hack out the HT-MSI on mcp51, the MSI will work well with
> sound card.
>
> this patch rework the nv_msi_ht_cap_quirk()
> and will only enable ht_msi and try to avoid to enable ht_msi both.
>
> Reported-by: Prakesh Punnoor <prakash@punnoor.de>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Hi, I can confirm that the patch works nicely with 2.6.29-rc6. (BTW, my name 
is written with two 'a's...)

Cheers,

Prakash

[snipped patch]
