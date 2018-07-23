From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: prevent ISA driver from building on PPC32
Date: Mon, 23 Jul 2018 01:18:11 -0700
Message-ID: <20180723081811.GA27025@infradead.org>
References: <5928f120-5a23-eff9-6c1d-41344d588b11@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <5928f120-5a23-eff9-6c1d-41344d588b11@infradead.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: PowerPC <linuxppc-dev@lists.ozlabs.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 21, 2018 at 12:58:21PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Prevent drivers from building on PPC32 if they use isa_bus_to_virt(),
> isa_virt_to_bus(), or isa_page_to_bus(), which are not available and
> thus cause build errors.

Please don't introduce weird arch dependencies, and add a
CONFIG_ISA_VIRT_TO_BUS instead.
