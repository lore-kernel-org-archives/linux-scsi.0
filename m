From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Mon, 24 Oct 2011 19:18:29 -0400
Message-ID: <20111024231829.GB25993@redhat.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
 <1319496149.2094.3.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1319496149.2094.3.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2011 at 03:42:29PM -0700, Joe Perches wrote:
 > James seems to be uninterested in picking up
 > obvious and trivially correct patches.
 > 
 > >From a year ago...
 > 
 > https://lkml.org/lkml/2010/10/31/123
 > 
 > James?
 
That's just ridiculous.
If maintainers aren't picking up obviously correct fixes[*], just send
them directly to Linus or Andrew.

	Dave

[*] Functional changes only, not janitor stuff. Just the patches fixing
    actual bugs.
