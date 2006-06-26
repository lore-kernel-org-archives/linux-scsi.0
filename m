From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization
	issue fix
Date: Mon, 26 Jun 2006 11:39:21 -0600
Message-ID: <m14py7u88m.fsf@ebiederm.dsl.xmission.com>
References: <20060623235553.2892f21a.akpm@osdl.org>
	<20060624111954.GA7313@in.ibm.com>
	<20060624043046.4e4985be.akpm@osdl.org>
	<20060624120836.GB7313@in.ibm.com>
	<m1veqqxyrb.fsf@ebiederm.dsl.xmission.com>
	<20060626021100.GA12824@in.ibm.com> <20060626133504.GA8985@in.ibm.com>
	<m11wtcvw5k.fsf@ebiederm.dsl.xmission.com>
	<20060626153239.GD8985@in.ibm.com>
	<m13bdrvrd4.fsf@ebiederm.dsl.xmission.com>
	<20060626171659.GG8985@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
In-Reply-To: <20060626171659.GG8985@in.ibm.com> (Vivek Goyal's message of
	"Mon, 26 Jun 2006 13:16:59 -0400")
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

> On Mon, Jun 26, 2006 at 10:00:55AM -0600, Eric W. Biederman wrote:

> I think it does hurt.
>
> - I have seen the case of MPT fusion drvier. It takes significantly more
>   time to come up if we choose to reset the device during initialization.
>   One of the reasons that we wait in a tight loop for the controller to =

>   come up after a reset message.
>
> - Long back we fixed ips driver and I remember that the maintainer had
>   a similar issue with the reset of device. He did not want to reset the
>   device in normal boot because otherwise it took significantly longer
>   for the driver to initialize.
>
> - Just now Mike also confirmed that resetting the device definitely
>   hurts in terms of time.

In the general case resets are trivial operations.  In scsi land =

things are different.  So a solution appropriate to that domain may
be appropriate.

Eric
