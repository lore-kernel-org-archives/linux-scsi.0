From: Tony Vroon <tony@vroon.org>
Subject: Re: [BUG 2.6.0-test10] SCSI update in CSET 1.1437.1.2 caused
	'Badness'
Date: Mon, 24 Nov 2003 16:40:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1069688448.4000.2.camel@localhost>
References: <50478.68.105.173.45.1069651886.squirrel@mail.mainstreetsoftworks.com>
	 <20031123234919.72ae0316.akpm@osdl.org>
	 <20031124080919.GA6969@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031124080919.GA6969@beaverton.ibm.com>
To: Mike Anderson <andmike@us.ibm.com>
Cc: Brad House <brad_mssw@gentoo.org>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2003-11-24 at 09:09, Mike Anderson wrote:
> This patch in the linux-scsi archives should remove this badness
> warning.
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106940008217622&w=2
> 
> It should apply cleanly to test10. I am just updating my view now to
> test10 so I have not tested the patch on test10 yet.
> 
> I did not have it refreshed in time from James to include it in his
> last update.

Confirmed, the badness and backtrace are no longer seen with this patch
applied.

Thank you,
Tony.
