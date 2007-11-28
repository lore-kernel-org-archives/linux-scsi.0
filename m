From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB cmds with sense info
Date: Wed, 28 Nov 2007 12:27:03 -0700
Message-ID: <20071128192703.GA2584@parisc-linux.org>
References: <20071127153252.GC3230@parisc-linux.org> <9738BCBE884FDB42801FAD8A7769C26501D33B5B@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761048AbXK1T1V@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501D33B5B@NAMAIL1.ad.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 28, 2007 at 12:08:37PM -0700, Yang, Bo wrote:
> Matthew,
> 
> Yes, as I mentioned, our applications are built in 32-bit environment
> (except for ia64).
> We may see a different behavior if we build it in 64-bit for x86-64. 

Then this patch isn't acceptable.  You need to find a way which works
for both 32-bit and 64-bit applications.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
