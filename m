From: Greg KH <greg@kroah.com>
Subject: Re: [Bugme-new] [Bug 22512] New: no disks are found at
 driver start after upgrate from 2.6.35.8 to 2.6.36
Date: Tue, 7 Dec 2010 13:23:32 -0800
Message-ID: <20101207212332.GF14849@kroah.com>
References: <bug-22512-10286@https.bugzilla.kernel.org/>
	<20101122162627.35f899de.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-bounces@linux.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101122162627.35f899de.akpm@linux-foundation.org>
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, stable@kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 22, 2010 at 04:26:27PM -0800, Andrew Morton wrote:
> On Tue, 9 Nov 2010 19:53:21 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=22512
> 
> >From this bug report it appears that
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4da26e162b69d89c3186a35a052c05e61a555637
> is needed in 2.6.36.x to fix a 2.6.35->2.6.36 regression.
> 
> But nobody remembered to add cc:<stable@kernel.org> to the changelog,
> so it got lost.

Thanks, I've queued it up for the next .36 kernel release.

If only the SCSI maintainer would tag patches for the stable trees,
things would be so much easier...

thanks,

greg k-h
