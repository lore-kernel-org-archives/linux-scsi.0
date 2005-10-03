From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsi: scsi inquiry timeout config option
Date: Mon, 03 Oct 2005 16:42:54 -0500
Message-ID: <4341A5DE.5030804@us.ibm.com>
References: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
	<1128373305.5825.3.camel@mulgrave> <4341A325.5070406@us.ibm.com>
	<Pine.LNX.4.58.0510031433030.6944@shark.he.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc64-dev-bounces@ozlabs.org>
In-Reply-To: <Pine.LNX.4.58.0510031433030.6944@shark.he.net>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc64-dev>
List-Post: <mailto:linuxppc64-dev@ozlabs.org>
List-Help: <mailto:linuxppc64-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc64-dev-bounces@ozlabs.org
Errors-To: linuxppc64-dev-bounces@ozlabs.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linuxppc64-dev@ozlabs.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Randy.Dunlap wrote:
> On Mon, 3 Oct 2005, Brian King wrote:
> 
> 
>>James Bottomley wrote:
>>
>>>On Mon, 2005-10-03 at 15:26 -0500, brking@us.ibm.com wrote:
>>>
>>>
>>>>Add a .config option to default the scsi scan inquiry timeout.
>>>>Due to a broken device (SCSI/ATA converter card) that is very
>>>>common on IBM iSeries/pSeries machines, these architectures
>>>>need a longer default inquiry timeout.
>>>
>>>
>>>The inquiry timeout has already been changed a while ago to be a module
>>>parameter (or kernel parameter) for this very case.  Why does it now
>>>need to be a config option as well?
>>
>>So that when a distro goes off and builds a PPC64 install kernel,
>>it can boot on one of these broken DVD-ROMs without requiring each
>>distro to add special module options inside their initrd.
> 
> 
> My reading on mailing lists is that distros prefer
> module or kernel parameters more than they do kernel config
> options (in general) because they are more dynamic -- it
> allows them to build one kernel instead of many kernels
> with various config options.

I agree with that statement, however.... Right now I am sitting with
an install ISO, trying to boot off this broken DVD-ROM, with scsi
compiled as a module in the install kernel, so I can't pass any
boot parameters to it in order to make it boot...

Additionally, this kernel config option does not decrease this dynamic
ability. The config option simply alters the default inquiry timeout.
If a module parm is passed at module load time, it will override the
default.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
