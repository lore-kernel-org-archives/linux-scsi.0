From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Date: Thu, 5 Jul 2007 11:28:38 -0700
Message-ID: <20070705112838.2d8c959b.akpm@linux-foundation.org>
References: <20070702183917.GJ4501@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070702183917.GJ4501@austin.ibm.com>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, matthew@wil.cx, willy@debian.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

On Mon, 2 Jul 2007 13:39:17 -0500
linas@austin.ibm.com (Linas Vepstas) wrote:

> 
> Various PCI bus errors can be signaled by newer PCI controllers.  
> This patch adds the PCI error recovery callbacks to the Symbios 
> SCSI device driver.  The patch has been tested, and appears to 
> work well.
> 

yup, this is identical to -mm's
pci-error-recovery-symbios-scsi-base-support.patch

What is the status of
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/pci-error-recovery-symbios-scsi-first-failure.patch?

> 
> ----
> 
> Hi,
> 
> This patch has been bouncing around for a long time, and has made
> appearences in various -mm trees since 2.6.something-teen. However,
> it has never made it into mainline, and I'm starting to get concerned
> that it will miss 2.6.23 as well. 

Well you've sent it a couple of times, and I've sent it in five more times
over the past year.  Once we were told "awaiting maintainer ack".

This situation is fairly stupid.  How about we make you the maintainer?
