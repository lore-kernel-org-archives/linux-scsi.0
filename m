From: <Yanqing_Liu@Dell.com>
Subject: Patch: add Dell product information into rdac device
	handler
Date: Tue, 30 Sep 2008 12:01:33 -0500
Message-ID: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0420246862=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Charles_Rose@Dell.com, mchristi@redhat.com, Shyam_Iyer@Dell.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--===============0420246862==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9231E.30F48F89"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9231E.30F48F89
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Hi all,=20

This patch is to add Dell Powervault storage arrays into device list for
rdac device handler.


--- linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
2008-09-29 02:31:26.000000000 -0400
+++ linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c
2008-09-30 02:06:26.000000000 -0400
@@ -590,6 +590,8 @@
 	{"STK", "OPENstorage D280"},
 	{"SUN", "CSM200_R"},
 	{"SUN", "LCSM100_F"},
+	{"DELL", "MD3000"},
+	{"DELL", "MD3000i"},
 	{NULL, NULL},
 };
=20

Thanks,
Yanqing

------_=_NextPart_001_01C9231E.30F48F89
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7653.38">
<TITLE>Patch: add Dell product information into rdac device =
handler</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi all, </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">This patch is to add Dell Powervault =
storage arrays into device list for rdac device handler.</FONT>
</P>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Courier New">--- =
linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig&nbsp;&nb=
sp;&nbsp; 2008-09-29 02:31:26.000000000 -0400</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">+++ =
linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c 2008-09-30 =
02:06:26.000000000 -0400</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">@@ -590,6 +590,8 @@</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {&quot;STK&quot;, =
&quot;OPENstorage D280&quot;},</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {&quot;SUN&quot;, =
&quot;CSM200_R&quot;},</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {&quot;SUN&quot;, =
&quot;LCSM100_F&quot;},</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {&quot;DELL&quot;, =
&quot;MD3000&quot;},</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {&quot;DELL&quot;, =
&quot;MD3000i&quot;},</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier =
New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {NULL, NULL},</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;};</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">&nbsp;</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Thanks,</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Yanqing</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C9231E.30F48F89--


--===============0420246862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0420246862==--
