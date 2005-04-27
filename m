From: Tim Pepper <tpepper@gmail.com>
Subject: Re: Re: fastfail operation and retries
Date: Wed, 27 Apr 2005 15:57:09 -0700
Message-ID: <eada2a0705042715573dd04ab1@mail.gmail.com>
References: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
	<20050421222409.GY17315@marowsky-bree.de>
	<ac71172a050422121365a32cc3@mail.gmail.com>
	<eada2a070504251656762a8625@mail.gmail.com>
	<20050427144406.GK4431@marowsky-bree.de>
Reply-To: Tim Pepper <tpepper@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050427144406.GK4431@marowsky-bree.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, tranlan@us.ibm.com, Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 4/27/05, Lars Marowsky-Bree <lmb@suse.de> wrote:
> User-space needs to take action and tell us when to stop queuing.

Is there any risk of priority inversion?  I can't think of a specific
issue beyond the userspace daemon process simply not existing that
wouldn't hopefully settle out over time and I haven't looked closely
at this aspect of 2.6, but it used to be easy to get/keep the cpu busy
enough on flushing IO to disk to hurt userspace response times (fibre
pulls during heavy buffered, filesystem IO effectively DoSing the
machine for a long period).  If that sort of thing is still possible,
it seems risky relying on a userspace application for
timely/meaningful recovery of the resources consumed by the IO.
