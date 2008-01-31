From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Thu, 31 Jan 2008 18:40:59 +0100
Message-ID: <e2e108260801310940s5a6e963cva6c106a82388065f@mail.gmail.com>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
	 <47A1EE54.6000005@vlnb.net>
	 <1201799660.11265.121.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964808AbYAaRl2@vger.kernel.org>
In-Reply-To: <1201799660.11265.121.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Jan 31, 2008 6:14 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> Also, with STGT being a pretty new design which has not undergone alot
> of optimization, perhaps profiling both pieces of code against similar
> tests would give us a better idea of where userspace bottlenecks reside.
> Also, the overhead involved with traditional iSCSI for bulk IO from
> kernel / userspace would also be a key concern for a much larger set of
> users, as iSER and SRP on IB is a pretty small userbase and will
> probably remain small for the near future.

Two important trends in data center technology are server
consolidation and storage consolidation. A.o. every web hosting
company can profit from a fast storage solution. I wouldn't call this
a small user base.

Regarding iSER and SRP on IB: InfiniBand is today the most economic
solution for a fast storage network. I do not know which technology
will be the most popular for storage consolidation within a few years
-- this can be SRP, iSER, IPoIB + SDP, FCoE (Fibre Channel over
Ethernet) or maybe yet another technology. No matter which technology
becomes the most popular for storage applications, there will be a
need for high-performance storage software.

References:
* Michael Feldman, Battle of the Network Fabrics, HPCwire, December
2006, http://www.hpcwire.com/hpc/1145060.html
* NetApp, Reducing Data Center Power Consumption Through Efficient
Storage, February 2007,
http://www.netapp.com/ftp/wp-reducing-datacenter-power-consumption.pdf

Bart Van Assche.
