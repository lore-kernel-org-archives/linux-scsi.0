From: "David S. Miller" <davem@redhat.com>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple
 map/unmaps
Date: Mon, 5 Jan 2004 19:04:39 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040105190439.0a5f7370.davem@redhat.com>
References: <200401051929.i05JTsM0000014248@mudpuddle.cs.wustl.edu.suse.lists.linux.kern
	el>
	<20040105112800.7a9f240b.davem@redhat.com.suse.lists.linux.kernel>
	<p73brpi1544.fsf@verdi.suse.de>
	<20040105130118.0cb404b8.davem@redhat.com>
	<20040105223158.3364a676.ak@suse.de>
	<1073347548.2439.33.camel@mulgrave>
	<20040106040640.1d2bcbd8.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040106040640.1d2bcbd8.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gibbs@scsiguy.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 6 Jan 2004 04:06:40 +0100
Andi Kleen <ak@suse.de> wrote:

> It's ok. I fixed the code now[1] If you have other undocumented requirements
> you should document them though, otherwise there may be more problems.
> Since merging is disabled by default now it won't trigger anyways.

I totally agree with you Andi, not documenting this properly was an
oversight and not intentional.
