From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [ANNOUNCE] hotplug-ng 001 release
Date: Fri, 18 Feb 2005 12:17:57 -0800
Message-ID: <20050218201756.GA23714@us.ibm.com>
References: <20050214224208.GC13110@suse.de> <20050216105117.GB2360@katya> <20050216110752.GC2360@katya> <1108594961l.5056l.5l@serve.riede.org> <20050216231741.GD2870@katya> <1108596771l.5056l.6l@serve.riede.org> <20050218171737.GA20012@us.ibm.com> <20050218181106.GC4424@katya> <20050218183350.GA21954@us.ibm.com> <20050218194135.GD4424@katya>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050218194135.GD4424@katya>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Roman Kagan <rkagan@mail.ru>, Willem Riede <osst@riede.org>, linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 18, 2005 at 10:41:35PM +0300, Roman Kagan wrote:
> On Fri, Feb 18, 2005 at 10:33:50AM -0800, Patrick Mansfield wrote:
> > The block SG_IO handles the ioctls, but not devices without a SCSI upper
> > level driver (i.e. not tape, disk or cdrom).
> 
> Then it might make sense to explicitly list in sg.c the TYPE_* not
> matched by s[dtr].

sg can be used even if another scsi upper level driver is loaded.

fedora core tried something like that for a while, I'm not sure what
happened (besides it being really hard to do), and haven't noticed
anything different in recent (2.6.x) fc kernels.

> So these drivers can compete for the same device?  Are there
> deterministic rules on which one is supposed to win?  And is there a
> userspace interface to unbind one driver and bind another?  Otherwise it
> may mean that automatic module loading is inappropriate here at all...

No to all.

It is OK to autoload sg, it has special handling. Even though greg
probably hates it, it is much better than a /proc/bus/scsi ;-)

-- Patrick Mansfield


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
