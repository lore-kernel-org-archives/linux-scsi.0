From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: mechanism for multipath to pass information to hardware
	handler
Date: Wed, 24 Jun 2009 13:14:41 -0400
Message-ID: <1245863681.8709.135.camel@eddie-laptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: SCSI development list <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org


I notice in scsi_dh_emc.c that there is a comment:

TODO: need some interface so we can set trespass values

I don't see where any such interface has been developed or even any
discussion on the different mailing lists to create such an interface.
Did I miss something?

As it stands now there is no way that I can see to have the emc hardware
handler support the "honor trespass" feature short of recompiling the
module forcing the flag to be set.  This leaves a feature that worked in
earlier versions of multipath not working now.

Eddie
