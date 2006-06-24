From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization
	issue fix
Date: Sat, 24 Jun 2006 11:13:44 -0600
Message-ID: <m1veqqxyrb.fsf@ebiederm.dsl.xmission.com>
References: <20060623210121.GA18384@in.ibm.com>
	<20060623210424.GB18384@in.ibm.com>
	<20060623235553.2892f21a.akpm@osdl.org>
	<20060624111954.GA7313@in.ibm.com>
	<20060624043046.4e4985be.akpm@osdl.org>
	<20060624120836.GB7313@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
In-Reply-To: <20060624120836.GB7313@in.ibm.com> (Vivek Goyal's message of
	"Sat, 24 Jun 2006 08:08:36 -0400")
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.osdl.org>
List-Help: <mailto:fastboot-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=subscribe>
Sender: fastboot-bounces@lists.osdl.org
Errors-To: fastboot-bounces@lists.osdl.org
To: vgoyal@in.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org, mike.miller@hp.com, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:

> On Sat, Jun 24, 2006 at 04:30:46AM -0700, Andrew Morton wrote:
>
>> > Or is there a generic way to handle these situations? Fixing them driv=
er
>> > by driver is a long painful process. =

>> =

>> Some generic way of whacking a PCI device via the standard PCI registers=
? =

>> Not that I know of.
>
> Somebody hinted that think of PCI bus reset. But I think PCI bus reset wi=
ll
> require firware/BIOS to export a hook to software to so initiate PCI bus
> reset and I don't think many platforms do that. Infact I am not even aware
> of one platform who does that.

Not all pci busses support it but there is a standard pci bus reset bit
in pci bridges.

I don't know if it would help but it might make sense to have a config
option that can be used to mark drivers that are known to have problems,
in these scenarios.

CONFIG_BRITTLE_INIT perhaps?

It would at least make it easier for people to see which drivers
they don't want to use, and give people some incentive to fix things.

Eric
