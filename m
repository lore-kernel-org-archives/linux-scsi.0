From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 4/7] mptfusion: mptlan Remove credits and update copyright
Date: Tue, 19 Apr 2005 15:11:50 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C020C3D4E@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C54524.67509280"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9463 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261674AbVDSVL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 17:11:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C54524.67509280
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 4/7:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.00/

Changelog:

(1) mptlan.c: Remove credits and update copyright
(2) mptlan.c: Remove -sralston references

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_000_01C54524.67509280
Content-Type: application/octet-stream;
	name="patch-4-mptlan"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-4-mptlan"

--- b/drivers/message/fusion/mptlan.c	2005-03-02 00:38:09.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptlan.c	2005-04-19 14:13:57.000000000 =
-0600=0A=
@@ -1,33 +1,11 @@=0A=
 /*=0A=
  *  linux/drivers/message/fusion/mptlan.c=0A=
  *      IP Over Fibre Channel device driver.=0A=
- *      For use with PCI chip/adapter(s):=0A=
- *          LSIFC9xx/LSI409xx Fibre Channel=0A=
+ *      For use with LSI Logic Fibre Channel PCI chip/adapters=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
+ *  Copyright (c) 2000-2005 LSI Logic Corporation=0A=
  *=0A=
- *      Special thanks goes to the I2O LAN driver people at the=0A=
- *      University of Helsinki, who, unbeknownst to them, provided=0A=
- *      the inspiration and initial structure for this driver.=0A=
- *=0A=
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      A really huge debt of gratitude is owed to Eddie C. Dost=0A=
- *      for gobs of hard work fixing and optimizing LAN code.=0A=
- *      THANK YOU!=0A=
- *=0A=
- *      (see also mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 2000-2004 LSI Logic Corporation=0A=
- *  Originally By: Noah Romer=0A=
- *  (mailto:mpt_linux_developer@lsil.com)=0A=
- *=0A=
- *  $Id: mptlan.c,v 1.53 2002/10/17 20:15:58 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -221,7 +199,7 @@=0A=
 =0A=
 		// NOTE!  (Optimization) First case here is now caught in=0A=
 		//  mptbase.c::mpt_interrupt() routine and callcack here=0A=
-		//  is now skipped for this case!  20001218 -sralston=0A=
+		//  is now skipped for this case!=0A=
 #if 0=0A=
 		case LAN_REPLY_FORM_MESSAGE_CONTEXT:=0A=
 //			dioprintk((KERN_INFO MYNAM "/lan_reply: "=0A=
@@ -234,7 +212,7 @@=0A=
 //			dioprintk((MYNAM "/lan_reply: "=0A=
 //				  "calling mpt_lan_send_reply (turbo)\n"));=0A=
 =0A=
-			// Potential BUG here?  -sralston=0A=
+			// Potential BUG here?=0A=
 			//	FreeReqFrame =3D mpt_lan_send_turbo(dev, tmsg);=0A=
 			//  If/when mpt_lan_send_turbo would return 1 here,=0A=
 			//  calling routine (mptbase.c|mpt_interrupt)=0A=
@@ -310,8 +288,7 @@=0A=
 =0A=
 	case MPI_FUNCTION_EVENT_NOTIFICATION:=0A=
 	case MPI_FUNCTION_EVENT_ACK:=0A=
-		/* UPDATE!  20010120 -sralston=0A=
-		 *  _EVENT_NOTIFICATION should NOT come down this path any more.=0A=
+		/*  _EVENT_NOTIFICATION should NOT come down this path any more.=0A=
 		 *  Should be routed to mpt_lan_event_process(), but just in =
case...=0A=
 		 */=0A=
 		FreeReqFrame =3D 1;=0A=
--- b/drivers/message/fusion/mptlan.h	2005-03-02 00:38:25.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptlan.h	2005-04-19 14:13:57.000000000 =
-0600=0A=
@@ -1,3 +1,49 @@=0A=
+/*=0A=
+ *  linux/drivers/message/fusion/mptlan.h=0A=
+ *      IP Over Fibre Channel device driver.=0A=
+ *      For use with LSI Logic Fibre Channel PCI chip/adapters=0A=
+ *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
+ *=0A=
+ *  Copyright (c) 2000-2005 LSI Logic Corporation=0A=
+ *=0A=
+ */=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
+    This program is free software; you can redistribute it and/or =
modify=0A=
+    it under the terms of the GNU General Public License as published =
by=0A=
+    the Free Software Foundation; version 2 of the License.=0A=
+=0A=
+    This program is distributed in the hope that it will be useful,=0A=
+    but WITHOUT ANY WARRANTY; without even the implied warranty of=0A=
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A=
+    GNU General Public License for more details.=0A=
+=0A=
+    NO WARRANTY=0A=
+    THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES =
OR=0A=
+    CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, =
WITHOUT=0A=
+    LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, =
NON-INFRINGEMENT,=0A=
+    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each =
Recipient is=0A=
+    solely responsible for determining the appropriateness of using =
and=0A=
+    distributing the Program and assumes all risks associated with =
its=0A=
+    exercise of rights under this Agreement, including but not limited =
to=0A=
+    the risks and costs of program errors, damage to or loss of =
data,=0A=
+    programs or equipment, and unavailability or interruption of =
operations.=0A=
+=0A=
+    DISCLAIMER OF LIABILITY=0A=
+    NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY =
FOR ANY=0A=
+    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+    DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER =
CAUSED AND=0A=
+    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, =
OR=0A=
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF =
THE=0A=
+    USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS =
GRANTED=0A=
+    HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES=0A=
+=0A=
+    You should have received a copy of the GNU General Public =
License=0A=
+    along with this program; if not, write to the Free Software=0A=
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  =
02111-1307  USA=0A=
+*/=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+=0A=
 /* mptlan.h */=0A=
 =0A=
 #ifndef LINUX_MPTLAN_H_INCLUDED=0A=
@@ -29,7 +75,7 @@=0A=
 #include <asm/io.h>=0A=
 =0A=
     /* Override mptbase.h by pre-defining these! */=0A=
-    #define MODULEAUTHOR "Noah Romer, Eddie C. Dost"=0A=
+#define MODULEAUTHOR	"LSI Logic Corporation"=0A=
 =0A=
 #include "mptbase.h"=0A=
 =0A=

------_=_NextPart_000_01C54524.67509280--
