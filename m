From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] cxlflash: Reset command ioasc
Date: Mon, 8 Jan 2018 10:43:49 -0600
Message-ID: <32405550-D504-416D-96B6-658E9DB2601C@linux.vnet.ibm.com>
References: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1515020042-43590-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <be8c1d08-f78a-a7f0-d912-e638646db80e@au1.ibm.com>
 <20180107193604.GB45065@p8tul1-build.aus.stglabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180107193604.GB45065@p8tul1-build.aus.stglabs.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

<html><head></head><body dir=3D"auto" style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;"><div =
class=3D"ApplePlainTextBody"><br><blockquote type=3D"cite">On Jan 7, =
2018, at 1:36 PM, Matthew R. Ochs &lt;mrochs@linux.vnet.ibm.com&gt; =
wrote:<br><br>On Thu, Jan 04, 2018 at 05:33:48PM +1100, Andrew Donnellan =
wrote:<br><blockquote type=3D"cite">On 04/01/18 09:54, Uma Krishnan =
wrote:<br><blockquote type=3D"cite">In the event of a command failure, =
cxlflash returns the failure to the<br>upper layers to process. After =
processing the error, when the command is<br>queued again, the private =
command structure will not be zeroed and the<br>ioasc could be stale. =
Per the SISLite specification, the AFU only sets the<br>ioasc in the =
presence of a failure. Thus, even though the original =
command<br>succeeds the second time, the command is considered a failure =
due to stale<br>ioasc. This cycle repeats indefinitely and can cause a =
hang or IO failure.<br><br>To fix the issue, clear the ioasc before =
queuing any command.<br><br>Fixes: 479ad8e9d48c ("scsi: cxlflash: Remove =
zeroing of private command<br>data")<br>Signed-off-by: Uma Krishnan =
&lt;ukrishn@linux.vnet.ibm.com&gt;<br></blockquote><br>Should this go to =
stable?<br></blockquote><br>Not a bad =
idea.<br><br></blockquote><br><br>I will forward the patch to stable =
once the patch is in next/master. <br>Unless there is a need to send a =
V2. Thanks for pointing out Andrew !!</div></body></html>=
