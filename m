From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Tue, 3 May 2005 13:11:02 +0200
Message-ID: <20050503111102.GJ1285@marowsky-bree.de>
References: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
	<20050421222409.GY17315@marowsky-bree.de>
	<ac71172a050422121365a32cc3@mail.gmail.com>
	<eada2a070504251656762a8625@mail.gmail.com>
	<20050427144406.GK4431@marowsky-bree.de>
	<eada2a0705042715573dd04ab1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <eada2a0705042715573dd04ab1@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tim Pepper <tpepper@gmail.com>, device-mapper development <dm-devel@redhat.com>
Cc: tranlan@us.ibm.com, Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 2005-04-27T15:57:09, Tim Pepper <tpepper@gmail.com> wrote:

> > User-space needs to take action and tell us when to stop queuing.
> Is there any risk of priority inversion?

That risk of course always exists (and it'd exist in the kernel too).
The code in question needs to be auditted to make sure this case is
taken care of.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
