From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/5] firewire: fw-sbp2: let SCSI shutdown commands	through
	before logout
Date: Mon, 18 Jun 2007 18:34:05 +0200
Message-ID: <4676B3FD.9010604@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>	
	<tkrat.86a8cf28dc784b39@s5r6.in-berlin.de>
	<1182180417.7928.13.camel@hinata.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1182180417.7928.13.camel@hinata.boston.redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Kristian H=F8gsberg wrote:
> On Sun, 2007-06-17 at 23:52 +0200, Stefan Richter wrote:
>> This affects of course only the "soft shutdown" case, e.g. "modprobe
>> -r
>> firewire-sbp2", while it doesn't matter for hot unplug.
> =

> Isn't this done when we remove the host?

Yes, we only need to defer the logout until after the host is removed.
I'll send updates to patch 2/5 and 3/5 in an hour which kick out the
sd->sdev member which I added in 2/5.

Of course all of this will be touched soon again when multi-LU support
is implemented.
-- =

Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D=3D- =3D--=3D-
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
