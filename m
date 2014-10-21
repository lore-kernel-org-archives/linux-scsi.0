From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Date: Tue, 21 Oct 2014 05:21:08 +0100
Message-ID: <20141021042108.GB11691@sucs.org>
References: <20141010074901.GA32028@sucs.org> <20141010075251.GC32028@sucs.org>
 <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 14, 2014 at 09:08:28PM -0400, Martin K. Petersen wrote:
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> Microsoft Hyper-V virtual disks currently only claim SPC-2
> Sitsofe> compliance causing the kernel skip checks for features such as
> Sitsofe> thin provisioning even though the virtual disk advertises them.
> 
> Last time around we identified this as a problem with Microsoft's
> interpretation of the T10 SBC spec. And they promised that they are
> going to fix that.

OK but if we were happy to wait for Microsoft to fix the problem on the
host why were the (broken and incomplete) BLIST_SKIP_VPD_PAGES patches
committed to 3.17 rather than withdrawn? What's going to be done about
those patches now?

-- 
Sitsofe | http://sucs.org/~sits/
