From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Add XEN pvSCSI support
Date: Fri, 27 Jun 2014 20:45:25 +0300
Message-ID: <20140627174525.GW18930@reaktio.net>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <1403879676-25431-1-git-send-email-jgross@suse.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: jgross@suse.com
Cc: James Harper <james.harper@bendigoit.com.au>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 27, 2014 at 04:34:32PM +0200, jgross@suse.com wrote:
> This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
> SCSI devices from a XEN domain.
> 
> The support consists of a backend in the privileged Domain-0 doing the real
> I/O and a frontend in the unprivileged domU passing I/O-requests to the backend.
> 
> The code is taken (and adapted) from the original pvSCSI implementation done
> for Linux 2.6 in 2008 by Fujitsu.
> 

Great! 

I added James Harper to CC, I know he has a port of at least scsiback aswell,
and he has a PVSCSI frontend driver included in the GPLPV Windows Xen PV drivers.

Btw do these patches also include the "latest" PVSCSI fixes/enhancements done in the SuSe/SLES kernel?
(for example the RESERVE/RELEASE support).

-- Pasi

> [PATCH 1/4] Add XEN pvSCSI protocol description
> [PATCH 2/4] Introduce xen-scsifront module
> [PATCH 3/4] Introduce XEN scsiback module
> [PATCH 4/4] add xen pvscsi maintainer
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
