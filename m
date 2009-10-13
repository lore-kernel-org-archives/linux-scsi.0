From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: SCSI driver for VMware's virtual HBA - V6.
Date: Tue, 13 Oct 2009 16:41:27 -0700
Message-ID: <20091013234127.GA9024@sequoia.sous-sol.org>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	<20091002004725.GP3958@sequoia.sous-sol.org>
	<1254789028.15233.54.camel@ank32.eng.vmware.com>
	<20091013053726.GE17547@sequoia.sous-sol.org>
	<1255470665.12792.105.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1255470665.12792.105.camel@ank32.eng.vmware.com>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/virtualization>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Alok Kataria <akataria@vmware.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "virtualization@lists.linux-foundataion.org" <virtualization@lists.linux-foundataion.org>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, James Bottomley <James.Bottomley@suse.de>, virtualization@lists.osdl.org, Daniel Walker <dwalker@fifo99.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

* Alok Kataria (akataria@vmware.com) wrote:
> SCSI driver for VMware's virtual HBA.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> This is a driver for VMware's paravirtualized SCSI device,
> which should improve disk performance for guests running
> under control of VMware hypervisors that support such devices.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>

Looks in good shape to me.

Reviewed-by: Chris Wright <chrisw@sous-sol.org>
