From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Mon, 24 Oct 2011 18:54:59 -0400
Message-ID: <20111024225459.GB25654@redhat.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
 <1319496149.2094.3.camel@Joe-Laptop>
 <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Joe Perches <joe@perches.com>, Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2011 at 12:50:08AM +0200, richard -rw- weinberger wrote:
 
 > BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
 > We could grep for "k[mzc]alloc(GFP_".

Make sure to ignore bio_kmalloc (which has reverse argument order to kmalloc, ugh)

	Dave
