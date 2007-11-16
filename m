From: Hannes Reinecke <hare@suse.de>
Subject: [Resend] [PATCH 3/3] multipath: implement controller
 framework for hardware handlers
Date: Fri, 16 Nov 2007 13:07:51 +0100
Message-ID: <473D8817.6040009@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050809070408080500030906"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050809070408080500030906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

This is a rework of the patch, based on your suggestions.
Command queueing for controller is now much simpler;
it's being enabled with dm_throttle_hw_controller() and
disabled with dm_flush_hw_controller().
Simpler logic and less error prone.

Tested here on an SGI TP9500.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------050809070408080500030906
Content-Type: text/x-patch;
	name*0="0003-multipath-implement-controller-framework-for-hardwa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="0003-multipath-implement-controller-framework-for-hardwa.pat";
	filename*1="ch"


--------------050809070408080500030906
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050809070408080500030906--
