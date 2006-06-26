From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization
	issue fix
Date: Mon, 26 Jun 2006 08:17:27 -0600
Message-ID: <m11wtcvw5k.fsf@ebiederm.dsl.xmission.com>
References: <20060623210121.GA18384@in.ibm.com>
	<20060623210424.GB18384@in.ibm.com>
	<20060623235553.2892f21a.akpm@osdl.org>
	<20060624111954.GA7313@in.ibm.com>
	<20060624043046.4e4985be.akpm@osdl.org>
	<20060624120836.GB7313@in.ibm.com>
	<m1veqqxyrb.fsf@ebiederm.dsl.xmission.com>
	<20060626021100.GA12824@in.ibm.com> <20060626133504.GA8985@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
In-Reply-To: <20060626133504.GA8985@in.ibm.com> (Vivek Goyal's message of
	"Mon, 26 Jun 2006 09:35:04 -0400")
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

> On Mon, Jun 26, 2006 at 07:41:00AM +0530, Maneesh Soni wrote:
>
> Maneesh, Keeping this code under a config option becomes a problem when we
> will have a relocatable kernel. At some point of time we got to have
> relocatable kernel so that people don't have to build two kernels. In fact
> this is becoming a pain area for distros. That's the reason I thought
> of making it a command line parameter.

Ok. Even if we do this with a command line, we need to have a clean concept.
If the concept is ignore devices with a brittle init routine that is compre=
hensible
and potentially useful for other reasons than crash dumps.

If the concept is crashdump it is a poorly defined concept and all of Andre=
ws
objections apply.

> I remember few months back, Eric had mentioned that he has got patches for
> relocatable kernel ready for review for i386 and x86_64. Eric, do you have
> any plans to post the patches for review?

I have some code that I keep intending to get to.  It has probably bit rott=
ed
since I wrote it, but it shouldn't be too bad to clean up.
Unfortunately the whole crashdump thing is fairly low on my priority list.

Although I suspect a relocatable kernel is actually easier than the more
important task of moving IRQ initialization into init_IRQ. on x86 and x86_6=
4.

At least I have managed to remove 3 layers of indirection in the x86_64 irq
handling code recently :)

Eric
