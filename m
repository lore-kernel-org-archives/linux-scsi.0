From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 22:41:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211224119.A23149@infradead.org>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E49698D.3030402@splentec.com>; from luben@splentec.com on Tue, Feb 11, 2003 at 04:22:21PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Feb 11, 2003 at 04:22:21PM -0500, Luben Tuikov wrote:
> :-)  yes, I know -- I was just saying that I don't like this policy
> that much.
> 
> It's an oxymoronic to grab a spin lock and say to someone, ok
> you can sleep, and then release the spin lock...

Agreed.  One of the things we really need to do is to change the calling
conventions of the eh methods to not have the lock held on entry.

I just wonder how we can archive that best without silently breaking
drivers.

