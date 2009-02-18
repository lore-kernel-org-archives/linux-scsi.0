From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 11:00:18 -0800
Message-ID: <200902181100.18928.jbarnes@virtuousgeek.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <499B9129.50104@kernel.org>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, February 17, 2009 8:40 pm Yinghai Lu wrote:
> Impact: workaround BIOS that doesn't enable that bit
>
> David reported that LSI sas doesn't work with MSI.
> it turns out that BIOS doesn't enable HT MSI
> 8132 does support HT MSI.
> add quirk to enable it
>
> Reported-by: David Lang <david@lang.hm>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
