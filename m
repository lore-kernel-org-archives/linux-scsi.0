From: =?iso-8859-1?Q?Thomas_Lang=E5s?= <tlan@stud.ntnu.no>
Subject: Re: Weird Qlogic 2200 FC HBA / CNSI G7324  problem
Date: Fri, 12 Jul 2002 11:18:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020712111842.A12686@stud.ntnu.no>
References: <20020712010844.A19115@stud.ntnu.no> <20020711164141.B8468@beaverton.ibm.com> <20020712024511.A15943@stud.ntnu.no> <20020712102334.A9789@stud.ntnu.no>
Reply-To: linux-scsi@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020712102334.A9789@stud.ntnu.no>; from tlan@stud.ntnu.no on Fri, Jul 12, 2002 at 10:23:34AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Thomas Lang=E5s:
> Just a quick update; doing the following works:
> echo "scsi add-single-device 1 0 0 1" > /proc/scsi/scsi
> Which indicates that's the detection code somewhere which
> isn't like it should?


And, to keep on replying to myself; the redhat kernel didn't=20
have "Probe all SCSI LUNs" enabled, adding that and it finds
everything like it should. Any reason why it doesn't without
this option?

--=20
Thomas
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
