From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Weird Qlogic 2200 FC HBA / CNSI G7324  problem
Date: Fri, 12 Jul 2002 09:16:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020712091603.A10141@beaverton.ibm.com>
References: <20020712010844.A19115@stud.ntnu.no> <20020711164141.B8468@beaverton.ibm.com> <20020712024511.A15943@stud.ntnu.no> <20020712102334.A9789@stud.ntnu.no> <20020712111842.A12686@stud.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020712111842.A12686@stud.ntnu.no>; from tlan@stud.ntnu.no on Fri, Jul 12, 2002 at 11:18:42AM +0200
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Thomas_Lang=E5s?= <tlan@stud.ntnu.no>
Cc: linux-scsi@vger.kernel.org

Thomas Lang=E5s [tlan@stud.ntnu.no] wrote:
> Thomas Lang=E5s:
> > Just a quick update; doing the following works:
> > echo "scsi add-single-device 1 0 0 1" > /proc/scsi/scsi
> > Which indicates that's the detection code somewhere which
> > isn't like it should?
>=20
>=20
> And, to keep on replying to myself; the redhat kernel didn't=20
> have "Probe all SCSI LUNs" enabled, adding that and it finds
> everything like it should. Any reason why it doesn't without
> this option?

With this config option not selected non zero luns will not be probed. =
You
can also pass max_scsi_luns on the command line without re-compiling yo=
ur
kernel. Someone from RedHat would be better to comment on the default
selection, but as you will see if you review the archive of this mail l=
ist
there have been passed issues of probing non-zero luns on older devices
not included in the scsi devicelist, so defaulting to off is possibly a
conservative selection.

-Mike
--=20
Michael Anderson
andmike@us.ibm.com

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
