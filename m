From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: DMA mapping on SCSI device?
Date: Mon, 28 Jan 2008 20:37:12 -0700
Message-ID: <20080129033712.GG20198@parisc-linux.org>
References: <479E6E8C.2090501@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479E6E8C.2090501@shaw.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 28, 2008 at 06:08:44PM -0600, Robert Hancock wrote:
> The 
> thought of using the SCSI struct device for DMA mapping was brought up 
> at one point.. any thoughts on that?

I believe this will work on some architectures and not others.
Anything that uses include/asm-generic/dma-mapping.h will break, for
example.  It would be nice for those architectures to get fixed ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
