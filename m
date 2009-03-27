From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [eSATA] 2.6.28.7: IO errors
Date: Fri, 27 Mar 2009 17:58:17 -0600
Message-ID: <20090327235817.GP8014@parisc-linux.org>
References: <Pine.LNX.4.64.0903280001020.4635@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903280001020.4635@axis700.grange>
Sender: linux-ide-owner@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 28, 2009 at 12:18:38AM +0100, Guennadi Liakhovetski wrote:
> I'm using an external eSATA / USB / Firewire 2x1T RAID from WD in RAID1 

Looks like your problems are solved by
9062712fa9ed13b531dfc2228086650b8bd6a255

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
