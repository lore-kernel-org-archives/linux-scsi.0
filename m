From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Fri, 22 Apr 2005 00:24:09 +0200
Message-ID: <20050421222409.GY17315@marowsky-bree.de>
References: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 2005-04-21T23:33:57, Andreas Herrmann <aherrman@de.ibm.com> wrote:

> Well, there are various situations when all paths to the ESS are
> "temporarily unavailable". In some cases TASK_SET_FULL/BUSY is
> reported as it should be.

Not sure whether this sense data is decoded and handled correctly in
dm-mpath yet. I don't have detailed specs, nor a feature request to
allocate time to work on making sure it really does. I recommend that
someone at IBM takes the real specs for the ESS and makes sure that it
all works, by a combination of the right defaults in the multipath-tools
hwtable and, if need be, a dm-ess plugin to handle this.

This would be much appreciated.

> underruns or exchange sequences are aborted and finally it might be
> that requests just time out. BTW, it is not only ESS where I have seen
> such (broken) behaviour.

Well, what can I say. Broken behaviour needs to be documented and worked
around, but obviously only as far as that is possible.

> > It is possible that to fully support them a dm mpath hardware handler
> > (like for the EMC CX family) might be required, too.
> For the time being I hope "queue_if_no_path" feature is sufficient
> to succesfully pass our tests ;-)

If it is sufficient, you might at least wish to update the
multipath-tools hwtable entry so that it is automagically set for your
arrays.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
