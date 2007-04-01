From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aacraid: Panics for AACRAID driver
	during	'insmod' for kexec test.
Date: Sun, 01 Apr 2007 12:46:46 -0500
Message-ID: <1175449607.27675.8.camel@mulgrave.il.steeleye.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9F1C@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.linux-foundation.org>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9F1C@otce2k301.adaptec.com>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.linux-foundation.org>
List-Help: <mailto:fastboot-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.linux-foundation.org?subject=subscribe>
Sender: fastboot-bounces@lists.linux-foundation.org
Errors-To: fastboot-bounces@lists.linux-foundation.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: fastboot@lists.osdl.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-03-30 at 14:48 -0400, Salyzyn, Mark wrote:
> My tree I am working on is 'more advanced' as it includes the series of o=
ther patches submitted over the past week :-( We have some interference goi=
ng on. I suggest pulling this patch until the others have cleared.

It applies OK for me (modulo the first make function static which
already went in) to scsi-misc-2.6

I've put it in scsi-misc-2.6 ... you can either pull it from there or
try -mm in a few days when Andrew refreshes from the maintainer trees.

Mark .. this also alters the way it gets treated ... since it's now on
upstream track, you need to tell me to pull it out if it has any
failures in testing, otherwise it will go into the vanilla kernel in
2.6.21

James
