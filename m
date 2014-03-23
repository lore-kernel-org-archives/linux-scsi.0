From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
Date: Sun, 23 Mar 2014 00:03:43 -0700
Message-ID: <20140323070343.GA17945@infradead.org>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
 <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
 <1395543886.3460.95.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1395543886.3460.95.camel@pasglop>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-ia64@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux@vger.kernel.org, linux-s390@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-scsi@vger.kernel.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, Laura Abbott <lauraa@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Sun, Mar 23, 2014 at 02:04:46PM +1100, Benjamin Herrenschmidt wrote:
> 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 1594945..8122294 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -82,6 +82,7 @@ config ARM
> >  	  <http://www.arm.linux.org.uk/>.
> >  
> >  config ARM_HAS_SG_CHAIN
> > +	select ARCH_HAS_SG_CHAIN
> >  	bool
> >  
> 
> Heh, a self-selecting config option... I didn't know that trick !

ARM vs ARCH.  However the arm variant of the variable should probably be
consolidated into the ARCH one as a follow up.
