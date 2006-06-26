From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver	initialization
	issue fix
Date: Mon, 26 Jun 2006 12:56:47 -0500
Message-ID: <1151344607.2673.14.camel@mulgrave.il.steeleye.com>
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
	<m14py7u88m.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
In-Reply-To: <m14py7u88m.fsf@ebiederm.dsl.xmission.com>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.osdl.org>
List-Help: <mailto:fastboot-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=subscribe>
Sender: fastboot-bounces@lists.osdl.org
Errors-To: fastboot-bounces@lists.osdl.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, mike.miller@hp.com, Neela.Kolli@engenio.com, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-06-26 at 11:39 -0600, Eric W. Biederman wrote:
> In the general case resets are trivial operations.  In scsi land =

> things are different.  So a solution appropriate to that domain may
> be appropriate.

That's not necessarily true. You're talking about board level resets
here.  Some devices take quite a while to reboot after being reset ...
particularly the complex ones with internal operating system type
firmware ..

James
