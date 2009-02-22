From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sun, 22 Feb 2009 16:42:31 -0700
Message-ID: <20090222234231.GB16891@parisc-linux.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <499FD623.1010105@kernel.org> <49A04F1E.7020006@gmail.com> <200902221308.55053.prakash@punnoor.de> <m1iqn2ein5.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42264 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbZBVXmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 18:42:49 -0500
Content-Disposition: inline
In-Reply-To: <m1iqn2ein5.fsf@fess.ebiederm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Prakash Punnoor <prakash@punnoor.de>, Robert Hancock <hancockrwd@gmail.com>, Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

On Sun, Feb 22, 2009 at 04:54:54AM -0800, Eric W. Biederman wrote:
> +				pci_write_config_dword(dev, pos + HT_MSI_ADDR_LO,
> +					(HT_MSI_FIXED_ADDR & HT_MSI_FIXED_ADDR));

Presumably you meant "(HT_MSI_FIXED_ADDR & 0xffffffff)" here?  Not that
it makes any difference, since it'll be implicitly truncated.

> +				pci_write_config_dword(dev, pos + HT_MSI_ADDR_HI,
> +					(HT_MSI_FIXED_ADDR >> 32));
> +			}

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
