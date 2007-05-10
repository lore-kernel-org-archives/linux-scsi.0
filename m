From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 6/9] Make scsi_host_template::proc_name const char *
	instead of char *.
Date: Thu, 10 May 2007 12:44:57 +0200
Message-ID: <4642F7A9.7060400@s5r6.in-berlin.de>
References: <11787529952207-git-send-email-krh@redhat.com>
	<11787530023454-git-send-email-krh@redhat.com>
	<11787530031570-git-send-email-krh@redhat.com>
	<11787530031450-git-send-email-krh@redhat.com>
	<11787530043878-git-send-email-krh@redhat.com>
	<11787530054176-git-send-email-krh@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090901080402000501000409"
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <11787530054176-git-send-email-krh@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Cc: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>, linux1394-devel <linux1394-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090901080402000501000409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Kristian H=F8gsberg wrote:
> Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
> ---
>  drivers/scsi/scsi_debug.c |    2 +-
>  include/scsi/scsi_host.h  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3e2930b..843f9c1 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2876,7 +2876,7 @@ static int __init scsi_debug_init(void)
> =20
>  	init_all_queued();
> =20
> -	sdebug_driver_template.proc_name =3D (char *)sdebug_proc_name;
> +	sdebug_driver_template.proc_name =3D sdebug_proc_name;
> =20
>  	host_to_add =3D scsi_debug_add_host;
>          scsi_debug_add_host =3D 0;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 7f1f411..0dfb5c2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -343,7 +343,7 @@ struct scsi_host_template {
>  	/*
>  	 * Name of proc directory
>  	 */
> -	char *proc_name;
> +	const char *proc_name;
> =20
>  	/*
>  	 * Used to store the procfs directory if a driver implements the

This has to go via James B and LSML.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D-=3D -=3D-=3D-
http://arcgraph.de/sr/

--------------090901080402000501000409
Content-Type: text/plain;
	name="Make-scsi_host_template-proc_name-const-char-instead-of-char.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="Make-scsi_host_template-proc_name-const-char-instead-of-char";
	filename*1=".patch"

From: =?utf-8?q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>
Subject: [PATCH 6/9] Make scsi_host_template::proc_name const char * instead of char *.
Date: Wed,  9 May 2007 19:23:12 -0400

Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
---
 drivers/scsi/scsi_debug.c |    2 +-
 include/scsi/scsi_host.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3e2930b..843f9c1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2876,7 +2876,7 @@ static int __init scsi_debug_init(void)
 
 	init_all_queued();
 
-	sdebug_driver_template.proc_name = (char *)sdebug_proc_name;
+	sdebug_driver_template.proc_name = sdebug_proc_name;
 
 	host_to_add = scsi_debug_add_host;
         scsi_debug_add_host = 0;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7f1f411..0dfb5c2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -343,7 +343,7 @@ struct scsi_host_template {
 	/*
 	 * Name of proc directory
 	 */
-	char *proc_name;
+	const char *proc_name;
 
 	/*
 	 * Used to store the procfs directory if a driver implements the


--------------090901080402000501000409
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
--------------090901080402000501000409
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090901080402000501000409--
