From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 13:06:56 +0100
Message-ID: <40736575.jvgUcOHqUx@wuerfel>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
 <1384905197-3566-4-git-send-email-lho@apm.com>
 <20131120113704.GT5914@e106331-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20131120113704.GT5914@e106331-lin.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jcm@redhat.com" <jcm@redhat.com>, "tj@kernel.org" <tj@kernel.org>, Loc Ho <lho@apm.com>, "olof@lixom.net" <olof@lixom.net>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 20 November 2013 11:37:05 Mark Rutland wrote:
> > +static void phy_rd(void *addr, u32 *val)
> > +{
> > +       *val = readl(addr);
> > +#if defined(XGENE_DBG1_CSR)
> > +       pr_debug("SATAPHY CSR RD: 0x%p value: 0x%08x\n", addr, *val);
> 
> Can you not use dev_dbg here as you do elsehere?
> 
> Either that or make your own debug print function, with the ifdefs
> hidden in its definition.
> 

pr_debug() is already conditional on #ifdef DEBUG, the extra #if
can just get removed here.

	Arnd
