From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Wed, 27 Apr 2005 16:44:06 +0200
Message-ID: <20050427144406.GK4431@marowsky-bree.de>
References: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
	<20050421222409.GY17315@marowsky-bree.de>
	<ac71172a050422121365a32cc3@mail.gmail.com>
	<eada2a070504251656762a8625@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <eada2a070504251656762a8625@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tim Pepper <tpepper@gmail.com>, device-mapper development <dm-devel@redhat.com>, tranlan@us.ibm.com
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 2005-04-25T16:56:56, Tim Pepper <tpepper@gmail.com> wrote:

> > queue_if_no_path must be used; I'm not sure why any dm-multipath
> > storage users would not want to turn on queue_if_no_path by default?
> What protection is there against long term queueing and running the
> machine out of memory?

User-space needs to take action and tell us when to stop queuing.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
